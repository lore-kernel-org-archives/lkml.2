Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2ELKX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 06:23:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37225 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761Ab2ELKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 06:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjYJFzMniWDO8wG57Zj6QxkGSRnKEue4b6MSuB0FU-W+Q@mail.gmail.com>
References: <CANQmPXjYJFzMniWDO8wG57Zj6QxkGSRnKEue4b6MSuB0FU-W+Q@mail.gmail.com>
Date: Sat, 12 May 2012 12:23:24 +0200
Message-ID: <CAFLxGvx4i19KxCtGcVGvt4ixWRxb3FSRqCN3KM2cgGz6ZsV-Ng@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH] Rotary Interactivity Favor Scheduler V2 Releaae
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: mou Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Con Kolivas <con@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Please create a nice series of patches and follow
Documentation/SubmittingPatches.
Otherwise nobody is able to review your scheduler.

BTW: Your patch touches lots of other files, why that?

$ grep rifs-patch-v2 -e "^diff"
diff -ruN linux-3.3.1/arch/powerpc/platforms/cell/spufs/sched.c
linux-3.3.1-RIFS/arch/powerpc/platforms/cell/spufs/sched.c
diff -ruN linux-3.3.1/arch/x86/Kconfig linux-3.3.1-RIFS/arch/x86/Kconfig
diff -ruN linux-3.3.1/arch/x86/kernel/cpu/proc.c
linux-3.3.1-RIFS/arch/x86/kernel/cpu/proc.c
diff -ruN linux-3.3.1/arch/x86/kernel/smpboot.c
linux-3.3.1-RIFS/arch/x86/kernel/smpboot.c
diff -ruN linux-3.3.1/Documentation/sysctl/kernel.txt
linux-3.3.1-RIFS/Documentation/sysctl/kernel.txt
diff -ruN linux-3.3.1/drivers/cpufreq/cpufreq.c
linux-3.3.1-RIFS/drivers/cpufreq/cpufreq.c
diff -ruN linux-3.3.1/drivers/cpufreq/cpufreq_conservative.c
linux-3.3.1-RIFS/drivers/cpufreq/cpufreq_conservative.c
diff -ruN linux-3.3.1/drivers/cpufreq/cpufreq_ondemand.c
linux-3.3.1-RIFS/drivers/cpufreq/cpufreq_ondemand.c
diff -ruN linux-3.3.1/fs/ext2/super.c~ linux-3.3.1-RIFS/fs/ext2/super.c~
diff -ruN linux-3.3.1/fs/proc/base.c linux-3.3.1-RIFS/fs/proc/base.c
diff -ruN linux-3.3.1/include/linux/init_task.h
linux-3.3.1-RIFS/include/linux/init_task.h
diff -ruN linux-3.3.1/include/linux/init_task.h~
linux-3.3.1-RIFS/include/linux/init_task.h~
diff -ruN linux-3.3.1/include/linux/jiffies.h
linux-3.3.1-RIFS/include/linux/jiffies.h
diff -ruN linux-3.3.1/include/linux/nfsd/stats.h
linux-3.3.1-RIFS/include/linux/nfsd/stats.h
diff -ruN linux-3.3.1/include/linux/sched.h
linux-3.3.1-RIFS/include/linux/sched.h
diff -ruN linux-3.3.1/include/linux/swap.h linux-3.3.1-RIFS/include/linux/swap.h
diff -ruN linux-3.3.1/include/net/inet_timewait_sock.h
linux-3.3.1-RIFS/include/net/inet_timewait_sock.h
diff -ruN linux-3.3.1/init/calibrate.c linux-3.3.1-RIFS/init/calibrate.c
diff -ruN linux-3.3.1/init/Kconfig linux-3.3.1-RIFS/init/Kconfig
diff -ruN linux-3.3.1/init/Kconfig~ linux-3.3.1-RIFS/init/Kconfig~
diff -ruN linux-3.3.1/init/main.c linux-3.3.1-RIFS/init/main.c
diff -ruN linux-3.3.1/kernel/delayacct.c linux-3.3.1-RIFS/kernel/delayacct.c
diff -ruN linux-3.3.1/kernel/exit.c linux-3.3.1-RIFS/kernel/exit.c
diff -ruN linux-3.3.1/kernel/Kconfig.hz linux-3.3.1-RIFS/kernel/Kconfig.hz
diff -ruN linux-3.3.1/kernel/Kconfig.preempt
linux-3.3.1-RIFS/kernel/Kconfig.preempt
diff -ruN linux-3.3.1/kernel/posix-cpu-timers.c
linux-3.3.1-RIFS/kernel/posix-cpu-timers.c
diff -ruN linux-3.3.1/kernel/sched/Makefile
linux-3.3.1-RIFS/kernel/sched/Makefile
diff -ruN linux-3.3.1/kernel/sched/rifs.c linux-3.3.1-RIFS/kernel/sched/rifs.c
diff -ruN linux-3.3.1/kernel/sysctl.c linux-3.3.1-RIFS/kernel/sysctl.c
diff -ruN linux-3.3.1/kernel/sysctl.c~ linux-3.3.1-RIFS/kernel/sysctl.c~
diff -ruN linux-3.3.1/lib/Kconfig.debug linux-3.3.1-RIFS/lib/Kconfig.debug
diff -ruN linux-3.3.1/Makefile linux-3.3.1-RIFS/Makefile
diff -ruN linux-3.3.1/mm/memory.c linux-3.3.1-RIFS/mm/memory.c
diff -ruN linux-3.3.1/mm/memory.c.orig linux-3.3.1-RIFS/mm/memory.c.orig
diff -ruN linux-3.3.1/mm/page-writeback.c linux-3.3.1-RIFS/mm/page-writeback.c
diff -ruN linux-3.3.1/mm/swapfile.c linux-3.3.1-RIFS/mm/swapfile.c
diff -ruN linux-3.3.1/mm/vmscan.c linux-3.3.1-RIFS/mm/vmscan.c
diff -ruN linux-3.3.1/mm/vmscan.c.orig linux-3.3.1-RIFS/mm/vmscan.c.orig

-- 
Thanks,
//richard
