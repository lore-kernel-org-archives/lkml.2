Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423366Ab2KNTZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:25:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423142Ab2KNTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:25:31 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=sJjTX9HOt0UA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9hUY60LNW4YA:10 a=7AXxmiD6hjIhq20cwmQA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352921129.18025.74.camel@gandalf.local.home>
Subject: Re: [PATCH 0/4] cputime: Even more cleanups
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 14 Nov 2012 14:25:29 -0500
In-Reply-To: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
References: <1352910413-10759-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 17:26 +0100, Frederic Weisbecker wrote:
> Hi,
> 
> While working on full dynticks, I realized some more cleanups needed to be
> done. Here is it. If no comment arise, I'll send a pull request to Ingo
> in a week.
> 

Other than what I've already commented on...

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Thanks.
> 
> Frederic Weisbecker (4):
>   vtime: Remove the underscore prefix invasion
>   vtime: Explicitly account pending user time on process tick
>   vtime: Consolidate a bit the ctx switch code
>   vtime: No need to disable irqs on vtime_account()
> 
>  arch/ia64/include/asm/cputime.h    |    2 ++
>  arch/ia64/kernel/time.c            |   24 ++++--------------------
>  arch/powerpc/include/asm/cputime.h |    2 ++
>  arch/powerpc/kernel/time.c         |   22 ++++++++--------------
>  arch/s390/include/asm/cputime.h    |    1 +
>  arch/s390/kernel/vtime.c           |   11 ++++++++---
>  include/linux/kernel_stat.h        |    8 ++++++++
>  include/linux/kvm_host.h           |    4 ++--
>  include/linux/vtime.h              |    9 +++++----
>  kernel/sched/cputime.c             |   31 +++++++++++++++++++------------
>  10 files changed, 59 insertions(+), 55 deletions(-)
> 


