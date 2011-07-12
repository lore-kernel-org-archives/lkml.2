Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1GLTfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 15:35:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52007 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1GLTfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 15:35:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.0, second try
Date: Tue, 12 Jul 2011 21:34:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Simon Guinot <sguinot@lacie.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Lei Wen <leiwen@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>
References: <201107081815.14283.arnd@arndb.de>
In-Reply-To: <201107081815.14283.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107122134.09530.arnd@arndb.de>
X-Provags-ID: V02:K0:srlotP6BIx6fwDCXrKDjhURyhCTir0Raocbd1Ixia8I
 9gD9xnCQh5oa3tnPpPf6afrTsw5Hm0mGVLfjxmoIkrcqBkuF6L
 FYMfEnFcUb66tSpQmYBRcoeR3iFACeWyX4PM3rvtVVUQPDSzZZ
 GiEc205lL23awlZp0Y+Q0R9hkfW3glG1043ESnaZpza3qtlG7z
 CaobKB68BHukT/2KZoBLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I received a few more PXA bug fixes from Eric since last week, so here is an
updated list. Please pull for 3.0.

Thanks,

	Arnd

On Friday 08 July 2011 18:15:14 Arnd Bergmann wrote:
> Another round of fixes from the arm-soc tree. The three patches for pxa are for
> long-standing bugs and will go in the stable trees. The other two are fixing
> fallout from the generic irqchip conversion.

The following changes since commit fe0d42203cb5616eeff68b14576a0f7e2dd56625:

  Linux 3.0-rc6 (2011-07-04 15:56:24 -0700)

are available in the git repository at:
  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/arm/linux-arm-soc.git/ fixes

Arnd Bergmann (1):
      Merge branch 'fix' of git://git.kernel.org/.../ycmiao/pxa-linux-2.6 into fixes

Daniel Mack (1):
      ARM: pxa/raumfeld: fix device name for codec ak4104

Jonathan Cameron (1):
      pcmcia: pxa2xx/vpac270: free gpios on exist rather than requesting

Lei Wen (2):
      ARM: pxa910: correct nand pmu setting
      ARM: pxa168: correct nand pmu setting

Linus Walleij (1):
      ARM: pxa: fix gpio_to_chip() clash with gpiolib namespace

Paul Parsons (1):
      ARM: pxa: fix PGSR register address calculation

Simon Guinot (1):
      genirq: replace irq_gc_ack() with {set,clr}_bit variants (fwd)

Sven Neumann (2):
      ARM: pxa/raumfeld: adapt to upcoming hardware change
      ARM: pxa/raumfeld: display initialisation fixes

Wolfram Sang (1):
      arm: mach-vt8500: add forgotten irq_data conversion

 arch/arm/mach-davinci/irq.c      |    2 +-
 arch/arm/mach-mmp/pxa168.c       |    2 +-
 arch/arm/mach-mmp/pxa910.c       |    2 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c   |    4 ++--
 arch/arm/mach-pxa/raumfeld.c     |   36 +++++++++++++++++++-----------------
 arch/arm/mach-vt8500/irq.c       |   21 ++++++++++++---------
 arch/arm/plat-orion/gpio.c       |    2 +-
 arch/arm/plat-pxa/gpio.c         |   10 +++++-----
 arch/arm/plat-s5p/irq-gpioint.c  |    2 +-
 arch/arm/plat-samsung/irq-uart.c |    2 +-
 drivers/pcmcia/pxa2xx_vpac270.c  |    4 ++--
 include/linux/irq.h              |    3 ++-
 kernel/irq/generic-chip.c        |   18 ++++++++++++++++--
 13 files changed, 64 insertions(+), 44 deletions(-)
