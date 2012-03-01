Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367Ab2CAXSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:18:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46878 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523Ab2CAXSi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:18:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of richard.weinberger@gmail.com designates 10.60.5.193 as permitted sender) smtp.mail=richard.weinberger@gmail.com; dkim=pass header.i=richard.weinberger@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120218023521.GB13538@smp.if.uj.edu.pl>
References: <20120218023521.GB13538@smp.if.uj.edu.pl>
Date: Fri, 2 Mar 2012 00:18:37 +0100
Message-ID: <CAFLxGvy0yWe2utG-+vFw4BhfH-i0vfjNy3k6kUsxkN7M4BSWQg@mail.gmail.com>
Subject: Re: ODEBUG: selftest warnings failed 4 != 5 (WARNING: at
 lib/debugobjects.c:908 check_results.constprop.9)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: akpm@linux-foundation.org, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 3:35 AM, Witold Baryluk
<baryluk@smp.if.uj.edu.pl> wrote:
> Hello everybody,
>
> I recently enabled a CONFIG_DEBUG_OBJECTS kconfig option, and this is what I got when booting
>
> ...
> [    0.000000] Linux version 3.3.0-rc3-t43-devel-smp-00278-g4903062-dirty (baryluk@sredniczarny) (gcc version 4.6.2 (Debian 4.6.2-14) ) #27 SMP Fri Feb 17 20:13:29 CE
> ...
> ...
> ...
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000]  RCU debugfs-based tracing is enabled.
> [    0.000000]  RCU lockdep checking is enabled.
> [    0.000000] NR_IRQS:2304 nr_irqs:256 16
> [    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 3823 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> ...
> ...
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 218 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] ODEBUG: 14 of 14 active objects replaced
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at lib/debugobjects.c:908 check_results.constprop.9+0x11c/0x140()
> [    0.000000] Hardware name: 2669UYD
> [    0.000000] ODEBUG: selftest warnings failed 4 != 5

This warning is still present.
Andrew?

-- 
Thanks,
//richard
