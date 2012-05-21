Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab2EUUeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:34:15 -0400
Received: from mail.southpole.se ([193.12.106.18]:35944 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab2EUUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:34:13 -0400
Message-ID: <1337632450.7558.34.camel@jerome.southpole.se>
Subject: [GIT PULL] OpenRISC updates for 3.5
From: Jonas Bonn <jonas@southpole.se>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 22:34:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 32450-12793
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit
d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://openrisc.net/jonas/linux tags/for-3.5

for you to fetch changes up to 207e715ff17b42e022df107210dc8c736a703eb3:

  openrisc: use scratch regs in atomic syscall (2012-05-08 11:43:59
+0200)

----------------------------------------------------------------
OpenRISC updates for 3.5

A couple of cleanups for the OpenRISC architecture:

* Implement IRQ domains
* Use DMA mapping framework completely and catch up with recent
  changes to dma_map_ops
* One bug fix to the "or1k_atomic" syscall to not clobber call-saved
  registers
* OOM killer patches to the pagefault handler ported from the X86 arch
* ...and a couple of header file cleanups

----------------------------------------------------------------
Jonas Bonn (5):
      openrisc: implement irqdomains
      openrisc: remove unnecessary includes
      openrisc: header file cleanups
      openrisc: provide dma_map_ops
      openrisc: use scratch regs in atomic syscall

Kautuk Consul (1):
      openrisc/mm/fault.c: Port OOM changes to do_page_fault

 arch/openrisc/Kconfig                   |    1 +
 arch/openrisc/include/asm/Kbuild        |    3 +-
 arch/openrisc/include/asm/dma-mapping.h |  147
+++++++------------------------
 arch/openrisc/include/asm/elf.h         |   12 ++-
 arch/openrisc/include/asm/ptrace.h      |    6 +-
 arch/openrisc/kernel/dma.c              |  109 +++++++++++++++--------
 arch/openrisc/kernel/entry.S            |    8 +-
 arch/openrisc/kernel/irq.c              |   83 +++++++++--------
 arch/openrisc/mm/fault.c                |   32 +++++--
 9 files changed, 199 insertions(+), 202 deletions(-)


