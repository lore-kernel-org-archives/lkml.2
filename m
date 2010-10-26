Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106Ab0JZQxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:53:23 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:48114 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758096Ab0JZQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:53:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EACSjxkzCTtAn/2dsb2JhbACDH54uca8VkhaBIoMydASKUw
Date: Tue, 26 Oct 2010 18:53:15 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: arch/m68knommu/kernel/asm-offsets.c compile error
Message-ID: <20101026165315.GA25736@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list readers,

Current vanilla kernel compilation fails very quickly with :

  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/m68knommu/kernel/asm-offsets.s
In file included from /archives/linux/git/arch/m68k/include/asm/system.h:2,
                 from include/linux/wait.h:25,
                 from include/linux/mmzone.h:9,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:12,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
                 from include/linux/hardirq.h:10,
                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
/archives/linux/git/arch/m68k/include/asm/system_no.h: In function ‘__xchg’:
/archives/linux/git/arch/m68k/include/asm/system_no.h:79: error: implicit declaration of function ‘local_irq_save’
/archives/linux/git/arch/m68k/include/asm/system_no.h:101: error: implicit declaration of function ‘local_irq_restore’
In file included from include/linux/mmzone.h:9,
                 from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:12,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
                 from include/linux/hardirq.h:10,
                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
include/linux/wait.h: At top level:
include/linux/wait.h:51: error: expected specifier-qualifier-list before ‘spinlock_t’
include/linux/wait.h: In function ‘waitqueue_active’:
include/linux/wait.h:115: error: ‘wait_queue_head_t’ has no member named ‘task_list’
include/linux/wait.h: In function ‘__add_wait_queue’:
include/linux/wait.h:124: error: ‘wait_queue_head_t’ has no member named ‘task_list’
include/linux/wait.h: In function ‘__add_wait_queue_tail’:
include/linux/wait.h:140: error: ‘wait_queue_head_t’ has no member named ‘task_list’
In file included from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:12,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
                 from include/linux/hardirq.h:10,
                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
include/linux/mmzone.h: At top level:
include/linux/mmzone.h:315: error: expected specifier-qualifier-list before ‘spinlock_t’
include/linux/mmzone.h: In function ‘zone_set_flag’:
include/linux/mmzone.h:428: error: ‘struct zone’ has no member named ‘flags’
include/linux/mmzone.h: In function ‘zone_test_and_set_flag’:
include/linux/mmzone.h:433: error: ‘struct zone’ has no member named ‘flags’
include/linux/mmzone.h: In function ‘zone_clear_flag’:
include/linux/mmzone.h:438: error: ‘struct zone’ has no member named ‘flags’
include/linux/mmzone.h: In function ‘zone_is_reclaim_locked’:
include/linux/mmzone.h:443: error: ‘const struct zone’ has no member named ‘flags’
include/linux/mmzone.h:443: error: ‘const struct zone’ has no member named ‘flags’
include/linux/mmzone.h: In function ‘zone_is_oom_locked’:
include/linux/mmzone.h:448: error: ‘const struct zone’ has no member named ‘flags’
include/linux/mmzone.h:448: error: ‘const struct zone’ has no member named ‘flags’
In file included from include/linux/gfp.h:4,
                 from include/linux/irq.h:20,
                 from include/asm-generic/hardirq.h:12,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq_no.h:17,
                 from /archives/linux/git/arch/m68k/include/asm/hardirq.h:2,
                 from include/linux/hardirq.h:10,
                 from /archives/linux/git/arch/m68k/include/asm/irqflags.h:5,
                 from include/linux/irqflags.h:15,
                 from include/linux/spinlock.h:53,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:56,
                 from arch/m68knommu/kernel/asm-offsets.c:12:
include/linux/mmzone.h: In function ‘populated_zone’:
include/linux/mmzone.h:687: error: ‘struct zone’ has no member named ‘present_pages’
include/linux/mmzone.h: In function ‘is_normal’:
include/linux/mmzone.h:736: error: ‘struct zone’ has no member named ‘zone_pgdat’
include/linux/mmzone.h: In function ‘is_dma’:
include/linux/mmzone.h:751: error: ‘struct zone’ has no member named ‘zone_pgdat’
make[1]: *** [arch/m68knommu/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Any idea ?

Philippe


-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
