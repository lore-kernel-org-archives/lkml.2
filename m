Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab1DWIOW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:14:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45330 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1DWIOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:14:19 -0400
Date: Sat, 23 Apr 2011 10:13:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110423081358.GB14952@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <1303508226.4865.8.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303508226.4865.8.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2011-04-22 at 10:06 +0200, Ingo Molnar wrote:
> > 
> > I'm about to push out the patch attached below - it lays out the arguments in 
> > detail. I don't think we have time to fix this properly for .39 - but memory 
> > profiling could be a nice feature for v2.6.40. 
> 
> Does something like the below provide enough generic infrastructure to
> allow the raw offcore bits again?

Yeah, this looks like a pretty good start - this is roughly the approach i 
outlined to Stephane and Andi, generic cache events extended with one more 
'node' level.

Andi, Stephane, if you'd like to see the Intel offcore bits supported in 2.6.40 
(or 2.6.41) please help out Peter with review, testing, tools/perf/ 
integration, etc.

Thanks,

	Ingo
