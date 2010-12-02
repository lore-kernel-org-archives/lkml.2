Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab0LBXBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:01:09 -0500
Received: from www.tglx.de ([62.245.132.106]:59249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038Ab0LBXBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:01:08 -0500
Date: Fri, 3 Dec 2010 00:00:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [GIT PULL 0/4] perf/core improvements
In-Reply-To: <1291318772-30880-1-git-send-email-acme@infradead.org>
Message-ID: <alpine.LFD.2.00.1012022358380.2653@localhost6.localdomain6>
References: <1291318772-30880-1-git-send-email-acme@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Arnaldo Carvalho de Melo wrote:

> Hi Ingo,
> 
>         Please consider pulling after at least Ian and Peter acks it:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core
> 
> 	Peter already acked a previous version of this, so I left his acked by
> there, this new one is much simpler than the first one he acked, so I think
> he'll be happy with this one as well, Peter?
> 
> 	I tested it using the perf tools built from what is in tip/perf/urgent
> and it works as expected, i.e. the new fields are just discarded since they are
> stashed as a trailer in the MMAP, FORK, etc events, so old tools process new
> perf.data files just fine.
> 
> 	Also the new tools works on older kernels, also tested.
> 
> 	Ian, if you prefer, please test it before Ingo merges it.

Did so. Have some odd fallout:

    tracepoint event: type 65535

    data->tid 2621441 data->pid 9

Investigating. Please wait

	       tglx

