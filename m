Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0JUR74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:59:56 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37795 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0JUR7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:59:55 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Oct 2010 11:59:32 -0600
X-Google-Sender-Auth: hq__TrzR4Sok8Ok11Im3Ip0BIYU
Message-ID: <AANLkTimqRRJhPEXneB6ba49TvbQogp9mDxe8=DTzU-q9@mail.gmail.com>
Subject: [git pull] SPI driver changes for 2.6.37
To: Linus Torvalds <torvalds@linux-foundation.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Daniel Mack <daniel@caiaq.de>, felipe.balbi@nokia.com,
        Jason Wang <jason77.wang@gmail.com>,
        Jassi Brar <jassi.brar@samsung.com>, Julia Lawall <julia@diku.dk>,
        Kevin Wells <kevin.wells@nxp.com>,
        Kumar Gala <kumar.gala@freescale.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Masayuki Ohtak <masa-korg@dsn.okisemi.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Mingkai Hu <Mingkai.hu@freescale.com>, yi.li@analog.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Nothing earth shattering here.  Just SPI device driver changes.  Please pull.

g.


The following changes since commit f6f94e2ab1b33f0082ac22d71f66385a60d8157f:

  Linux 2.6.36 (2010-10-20 13:30:22 -0700)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 next-spi

Barry Song (6):
      spi/bfin_spi: fix CS handling
      spi/bfin_spi: redo GPIO CS handling
      spi/bfin_spi: save/restore state when suspending/resuming
      spi/bfin_spi: sync hardware state before reprogramming everything
      spi/bfin_spi: use dma_disable_irq_nosync() in irq handler
      spi/bfin_spi: warn when CS is driven by hardware (CPHA=0)

Bob Liu (1):
      spi/bfin_spi: check per-transfer bits_per_word

Daniel Mack (1):
      spi/bfin_spi: fix resources leakage

Felipe Balbi (1):
      spi: omap2_mcspi: make use of dev_vdbg()

Grant Likely (5):
      spi/topcliff: cleanups for style and conciseness
      spi/topcliff: Tidy up Kconfig help text
      Merge commit 'v2.6.36-rc7' into spi/next
      spi/topcliff: Fix uninitialized variable defect
      Merge branch 'for-spi' of
git://git.kernel.org/.../vapier/blackfin into spi/next

Ilkka Koskinen (1):
      spi/omap2_mcspi: Verify TX reg is empty after TX only xfer with DMA

Jason Wang (1):
      spi/omap2_mcspi: disable channel after TX_ONLY transfer in PIO mode

Jassi Brar (3):
      spi/s3c64xx: Prevent unnecessary map-unmap
      spi/s3c64xx: Consider the clk_from_cmu flag
      spi/s3c64xx: Correction for 16,32 bits bus width

Julia Lawall (2):
      spi/orion: Drop unnecessary null test
      spi/amba-pl022: Fix error case return statement.

Kevin Wells (1):
      spi/pl022: Add spi->mode support to AMBA SPI driver

Kumar Gala (1):
      spi/fsl_spi: Fix compile errors when building on ppc64

Linus Walleij (3):
      spi/pl022: add PrimeCell generic DMA support
      spi/pl022: get rid of chipinfo dev pointer
      spi/pl022: fix dubious allocation staticize platform data

Masayuki Ohtake (1):
      spi/topcliff: Add topcliff platform controller hub (PCH) spi bus driver

Matthias Brugger (2):
      spi/atmel: let transfers through if not changing bits_per_word
      spi/atmel: typo in debug message

Michael Hennerich (1):
      spi/bfin_spi: init early

Mike Frysinger (14):
      spi/bfin_spi: drop custom cs_change_per_word support
      spi/bfin_spi: punt useless null read/write funcs
      spi/bfin_spi: fix up some unused/misleading comments
      spi/bfin_spi: convert queue run state to true/false
      spi/bfin_spi: convert read/write/duplex funcs to a dedicated ops structure
      spi/bfin_spi: convert struct names to something more logical
      spi/bfin_spi: drop extra memory we don't need
      spi/bfin_spi: use the SPI namespaced bit names
      Blackfin: SPI: expand SPI bitmasks
      spi/bfin_spi: push all size checks into the transfer function
      spi/bfin_spi: reset ctl_reg bits when setup is run again on a device
      spi/bfin_spi: combine duplicate SPI_CTL read/write logic
      spi/bfin_spi: reject unsupported SPI modes
      spi/bfin_spi: namespace local structs

Mingkai Hu (4):
      spi/mpc8xxx: rename spi_mpc8xxx.c to spi_fsl_spi.c
      spi/mpc8xxx: refactor the common code for SPI/eSPI controller
      spi/fsl_spi: add eSPI controller support
      powerpc/of: add eSPI controller dts bindings and DTS modification

Rob Maris (2):
      spi/bfin_spi: fix typo in comment
      spi/bfin_spi: cs should be always low when a new transfer begins

Sonic Zhang (1):
      spi/bfin_spi: work around anomaly 05000119

Wolfgang Muees (1):
      spi/bfin_spi: force sane master-mode state at boot

Yi Li (2):
      spi/bfin_spi: utilize the SPI interrupt in PIO mode
      spi/bfin_spi: use nosync when disabling the IRQ from the IRQ handler

matt mooney (1):
      spi: change to new flag variable

 Documentation/powerpc/dts-bindings/fsl/spi.txt   |   24 +-
 arch/arm/mach-lpc32xx/phy3250.c                  |    7 +-
 arch/arm/mach-u300/dummyspichip.c                |    5 +-
 arch/arm/mach-u300/spi.c                         |   10 +-
 arch/arm/mach-ux500/board-mop500.c               |    8 +-
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h |    3 +
 arch/blackfin/include/asm/bfin5xx_spi.h          |   81 +--
 arch/powerpc/boot/dts/mpc8536ds.dts              |   52 +
 arch/powerpc/boot/dts/p4080ds.dts                |   11 +-
 drivers/mfd/ab8500-spi.c                         |    5 +
 drivers/spi/Kconfig                              |   30 +-
 drivers/spi/Makefile                             |    9 +-
 drivers/spi/amba-pl022.c                         |  751 +++++++++----
 drivers/spi/atmel_spi.c                          |   14 +-
 drivers/spi/omap2_mcspi.c                        |   81 +-
 drivers/spi/orion_spi.c                          |    4 +-
 drivers/spi/spi_bfin5xx.c                        |  844 ++++++++-------
 drivers/spi/spi_fsl_espi.c                       |  748 +++++++++++++
 drivers/spi/spi_fsl_lib.c                        |  237 ++++
 drivers/spi/spi_fsl_lib.h                        |  124 ++
 drivers/spi/{spi_mpc8xxx.c => spi_fsl_spi.c}     |  552 +++-------
 drivers/spi/spi_s3c64xx.c                        |  158 ++-
 drivers/spi/spi_topcliff_pch.c                   | 1303 ++++++++++++++++++++++
 include/linux/amba/pl022.h                       |   13 +-
 24 files changed, 3842 insertions(+), 1232 deletions(-)
 create mode 100644 drivers/spi/spi_fsl_espi.c
 create mode 100644 drivers/spi/spi_fsl_lib.c
 create mode 100644 drivers/spi/spi_fsl_lib.h
 rename drivers/spi/{spi_mpc8xxx.c => spi_fsl_spi.c} (64%)
 create mode 100644 drivers/spi/spi_topcliff_pch.c


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
