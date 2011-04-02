Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1DBIyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 04:54:31 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41699 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab1DBIy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 04:54:29 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: [GIT PULL] UniCore32 ISA & PKUnity SoC patches for linux-2.6.39-rc1
Date: Sat, 2 Apr 2011 16:54:13 +0800
Message-ID: <002701cbf113$8c8db180$a5a91480$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AcvxEtlb3yIVdD+NRLeYmB9Tv3Txig==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
   Could you please pull from:
     git://git.kernel.org/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git unicore32
   to add unicore32 isa & pkunity soc patches for linux-2.6.39-rc1.

Thanks & regards,

Guan Xuetao

Guan Xuetao (4):
  unicore32 ldscript fix: add cacheline parameter to PERCPU() macro
  unicore32 fix: remove arch-specific futex support
  unicore32 rtc driver fix: cleanup irq_set_freq and irq_set_state
  unicore32 framebuffer fix: get videomemory by __get_free_pages() and
    make it floatable

Huang Weiyi (1):
  unicore32 core architecture: remove duplicated #include

 arch/unicore32/Makefile               |    2 +-
 arch/unicore32/include/asm/futex.h    |  143 ---------------------------------
 arch/unicore32/include/mach/PKUnity.h |   10 ---
 arch/unicore32/include/mach/memory.h  |    1 -
 arch/unicore32/kernel/puv3-core.c     |    5 -
 arch/unicore32/kernel/rtc.c           |    9 --
 arch/unicore32/kernel/setup.c         |   15 +---
 arch/unicore32/kernel/traps.c         |    1 -
 arch/unicore32/kernel/vmlinux.lds.S   |    7 +-
 arch/unicore32/mm/mmu.c               |   20 -----
 drivers/video/fb-puv3.c               |   28 ++++---
 11 files changed, 24 insertions(+), 217 deletions(-)
 delete mode 100644 arch/unicore32/include/asm/futex.h


