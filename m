Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1GFRQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:16:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab1GFRQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:16:11 -0400
Date: Wed, 6 Jul 2011 19:15:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110706171559.GA14208@elte.hu>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
 <20110706165357.GG4590@erda.amd.com>
 <20110706171015.GA13869@elte.hu>
 <1309972481.3282.319.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309972481.3282.319.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2011-07-06 at 19:10 +0200, Ingo Molnar wrote:
> > 
> > I think Peter suggested it that an open() done in /sys should 
> > give us a handle to a given event?
> 
> No, more like the open of a sysfs file could also grab a refcount 
> on the module. All it would take is a custom open/close method for 
> sysfs files. Now I have no clue how to do that, but that's another 
> issue.
> 
> Also, I really don't see the point. With modular PMUs there's 
> always races against unload, just don't do that or live with it.

I don't think it's a big issue either - module load/unloads are rare.

Thanks,

	Ingo
