Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1DINRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:17:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab1DINRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:17:18 -0400
Date: Sat, 9 Apr 2011 15:17:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf: Don't schedule tracepoints when exclude_kernel is
 set
Message-ID: <20110409131702.GA14331@elte.hu>
References: <1302296275-26767-1-git-send-email-fweisbec@gmail.com>
 <1302354884.9086.1272.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302354884.9086.1272.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2011-04-08 at 22:57 +0200, Frederic Weisbecker wrote:
> > Instead of checking attr.exclude_kernel anytime a tracepoint
> > event triggers, simply don't schedule the tracepoint it that
> > attribute is set. This makes one test less in the tracing
> > path.
> 
> Meh, I'd much rather someone spend some time on finishing the below,
> which is a much bigger improvement for trace-events.
> 
> ---
> Subject: perf: Tracepoint collection support
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Sat Nov 20 18:09:34 CET 2010
> 
> Due to popular demand this implements a tracepoint collection event
> { .type = PERF_TYPE_TRACEPOINT, .config = ~0ULL }. by default it
> contains no tracepoints, but tracepoints can be added using:
>   ioctl(fd, PERF_EVENT_IOC_ADD_TP, tp_id);

+1 !!!

This is like a super-important feature.

Thanks,

	Ingo
