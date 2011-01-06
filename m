Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1AFH4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:56:35 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:50141 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1AFH4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:56:34 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 0/8] unicore32 machine related files: summary
Date: Thu, 6 Jan 2011 15:56:35 +0800
Message-ID: <01de01cbad77$3dbed0a0$b93c71e0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcutdN+H6CMsGCTsTY+zfNQC8VTI6Q==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

The whole patch could be fetched from:
  git://git.kernel.org/pub/scm/linux/kernel/git/epip/unicore32.git
  with branch name: unicore32.
And it is divided into  three patch sets: core architecture files,
  additional architecture files, and machine related files.

This patch set adds the machine related files for UniCore32 ISA and PKUnity SoC. 

Patch 1 adds machine related  core files, also including build infrastructure.

Patch 2 add all hardware registers definitions, which are not split and inserted into
 different drivers.

Patch 3 implements arch-specific pci bus driver.

Patch 4 implements arch-specific ps2 dirver.

Patch 5 implements frame buffer driver.

Patch 6 implements ac97 driver.

Patch 7 implements arch-specific i2c bus driver.

Patch 8 implements network driver.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/mach/PKUnity.h     |  104 ++
 arch/unicore32/include/asm/mach/bitfield.h    |   24 +
 arch/unicore32/include/asm/mach/hardware.h    |   45 +
 arch/unicore32/include/asm/mach/regs-ac97.h   |   32 +
 arch/unicore32/include/asm/mach/regs-dmac.h   |   81 +
 arch/unicore32/include/asm/mach/regs-gpio.h   |   70 +
 arch/unicore32/include/asm/mach/regs-i2c.h    |   63 +
 arch/unicore32/include/asm/mach/regs-intc.h   |   28 +
 arch/unicore32/include/asm/mach/regs-nand.h   |   79 +
 arch/unicore32/include/asm/mach/regs-ost.h    |   92 ++
 arch/unicore32/include/asm/mach/regs-pci.h    |   94 ++
 arch/unicore32/include/asm/mach/regs-pm.h     |  126 ++
 arch/unicore32/include/asm/mach/regs-ps2.h    |   20 +
 arch/unicore32/include/asm/mach/regs-resetc.h |   34 +
 arch/unicore32/include/asm/mach/regs-rtc.h    |   37 +
 arch/unicore32/include/asm/mach/regs-sdc.h    |  156 ++
 arch/unicore32/include/asm/mach/regs-spi.h    |   98 ++
 arch/unicore32/include/asm/mach/regs-uart.h   |    3 +
 arch/unicore32/include/asm/mach/regs-umal.h   |  229 +++
 arch/unicore32/include/asm/mach/regs-unigfx.h |  200 +++
 arch/unicore32/include/asm/pci.h              |   46 +
 arch/unicore32/kernel/pci.c                   |  404 +++++
 arch/unicore32/kernel/puv3-core.c             |  266 ++++
 arch/unicore32/kernel/puv3-nb0916.c           |  183 +++
 arch/unicore32/kernel/puv3-smw0919.c          |  120 ++
 drivers/input/keyboard/Kconfig                |   11 +
 drivers/input/keyboard/atkbd.c                |    4 +
 drivers/input/mouse/psmouse-base.c            |   41 +
 drivers/input/serio/i8042.h                   |    2 +
 drivers/pci/Makefile                          |    1 +
 drivers/staging/puv3/Kconfig                  |  142 ++
 drivers/staging/puv3/Makefile                 |   27 +
 drivers/staging/puv3/TODO                     |    7 +
 drivers/staging/puv3/i8042-ucio.h             |   96 ++
 drivers/staging/puv3/nb0916-atkbd.h           |   43 +
 drivers/staging/puv3/puv3_ac97.c              |  383 +++++
 drivers/staging/puv3/puv3_i2c.c               |  325 ++++
 drivers/staging/puv3/puv3_pcm.c               |  449 ++++++
 drivers/staging/puv3/puv3_pcm.h               |   33 +
 drivers/staging/puv3/puv3_umal.c              | 2082 +++++++++++++++++++++++++
 drivers/staging/puv3/puv3_unifb.c             |  972 ++++++++++++
 include/linux/fb.h                            |    2 +
 42 files changed, 7254 insertions(+), 0 deletions(-)

