Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0KYM3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 07:29:47 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46891 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0KYM3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 07:29:46 -0500
Date: Thu, 25 Nov 2010 17:59:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 1/4] taskstats: Introduce "struct cdata"
Message-ID: <20101125122938.GC3298@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101119201108.269346583@linux.vnet.ibm.com>
 <20101119201143.787050299@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101119201143.787050299@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Holzheu <holzheu@linux.vnet.ibm.com> [2010-11-19 21:11:09]:

> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> This patch introduces a new structure "struct cdata" that is used to
> store cumulative resource counters for dead child processes and threads.
> 
> Note that there is one asymmetry:
> For "struct task_io_accounting" (ioc) there is no extra accounting field for
> dead threads. One field is used for both, dead processes and threads.
> 
> This patch introduces no functional change.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> ---
>  fs/binfmt_elf.c           |    4 +-
>  fs/exec.c                 |    2 -
>  fs/proc/array.c           |   16 ++++----
>  include/linux/sched.h     |   22 +++++++----
>  kernel/exit.c             |   86 ++++++++++++++++++++++++----------------------
>  kernel/posix-cpu-timers.c |   12 +++---
>  kernel/sys.c              |   44 ++++++++++++-----------
>  7 files changed, 100 insertions(+), 86 deletions(-)

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Three Cheers,
	Balbir
