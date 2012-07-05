Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab2GEQns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab2GEQnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:43:47 -0400
Date: Thu, 5 Jul 2012 13:43:05 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        mingo@elte.hu, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        andi@firstfloor.org, drepper@gmail.com
Subject: Re: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
Message-ID: <20120705164305.GD7533@infradead.org>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
 <1340960907-3725-3-git-send-email-jolsa@redhat.com>
 <87bojync4b.fsf@sejong.aot.lge.com>
 <20120702101010.GB967@krava.redhat.com>
 <873959mzi3.fsf@sejong.aot.lge.com>
 <20120704173407.GA2880@krava.redhat.com>
 <1341504351.7709.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341504351.7709.6.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jul 05, 2012 at 06:05:51PM +0200, Peter Zijlstra escreveu:
> On Wed, 2012-07-04 at 19:34 +0200, Jiri Olsa wrote:
> > or any other way.. ;) thoughts?
> 
> What again was the downside if always doing additive (instead of
> overriding) attributes?

Yeah, I think this is the sanest way: additive. Overriding is confusing.

- Arnaldo
