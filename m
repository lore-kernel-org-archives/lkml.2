Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab0E0XI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 19:08:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759019Ab0E0XIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 19:08:55 -0400
Date: Thu, 27 May 2010 20:08:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, v2] perf changes
Message-ID: <20100527230815.GN9874@ghostprotocols.net>
References: <20100524192531.GA15614@elte.hu>
 <20100525002221.GA30395@drongo>
 <20100525135200.GA21462@elte.hu>
 <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005271533010.11382@i5.linux-foundation.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 03:34:51PM -0700, Linus Torvalds escreveu:
> 
> 
> On Tue, 25 May 2010, Ingo Molnar wrote:
> >
> >  75 files changed, 1847 insertions(+), 3147 deletions(-)
> 
> I was excited by this ("A code _reduction_! Will wonders never cease?"), 
> but it turns out that all of the reduction was due to removing some unused 
> utility functions from the user-level tools.

That was Ingo's forward looking investments, which I decided to take off
the balance sheet not to get the IMF on our backs, glad you noticed the
trick, never the less, it was at least a step on the right direction, I
guess.
 
> The actual kernel still grew:
> 
>  32 files changed, 1327 insertions(+), 964 deletions(-)
> 
> oh well. Merged anyway.

Thanks!

> 		Linus

- Arnaldo
