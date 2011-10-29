Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1J2FJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 01:09:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47208 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1J2FJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 01:09:47 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 29 Oct 2011 07:09:27 +0200
X-Google-Sender-Auth: 1BLX_7FvS4M6t4a2DYku1aZ8bqM
Message-ID: <CACxGe6t4rUcu=qwc0WXNfjpejfZuu_D1wLvQ=x683rQZrM0faw@mail.gmail.com>
Subject: [git pull] spi driver changes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another unexciting spi driver pull.  Only spi driver fixes, plus one
patch that eliminates a lot of boilerplate on platform drivers.

g.

The following changes since commit ec7ae517537ae5c7b0b2cd7f562dfa3e7a05b954:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
(2011-10-28 16:44:18 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/next

Grant Likely (2):
      Merge commit 'v3.1' into spi/next
      drivercore: Add helper macro for platform_driver boilerplate

H Hartley Sweeten (1):
      spi: spi-dw: fix all sparse warnings

Marc Dietrich (1):
      spi/tegra: fix compilation error in spi-tegra.c

Mika Westerberg (1):
      spi/spi-ep93xx: add module.h include

Shubhrajyoti D (1):
      OMAP: SPI: Fix the trying to free nonexistent resource error

Viresh Kumar (5):
      spi/spi-pl022: Resolve formatting issues
      spi/spi-pl022: Use GFP_ATOMIC for allocation from tasklet
      spi/spi-pl022: Don't allocate more sg than required.
      spi/spi-pl022: calculate_effective_freq() must set rate <= requested rate
      spi/spi-pl022: Call pl022_dma_remove(pl022) only if enable_dma is true

Yong Zhang (1):
      spi: irq: Remove IRQF_DISABLED

 drivers/spi/spi-altera.c        |   13 +---
 drivers/spi/spi-ath79.c         |   13 +---
 drivers/spi/spi-atmel.c         |   13 +---
 drivers/spi/spi-bfin-sport.c    |   13 +---
 drivers/spi/spi-bfin5xx.c       |    2 +-
 drivers/spi/spi-coldfire-qspi.c |   16 +----
 drivers/spi/spi-davinci.c       |   20 ++----
 drivers/spi/spi-dw-mid.c        |    9 ++-
 drivers/spi/spi-dw-mmio.c       |   14 +---
 drivers/spi/spi-dw.c            |   62 ++++++++--------
 drivers/spi/spi-dw.h            |   97 ++++++++++++++------------
 drivers/spi/spi-ep93xx.c        |   21 ++----
 drivers/spi/spi-fsl-espi.c      |   13 +---
 drivers/spi/spi-gpio.c          |   21 ++----
 drivers/spi/spi-imx.c           |   14 +----
 drivers/spi/spi-mpc512x-psc.c   |   13 +---
 drivers/spi/spi-mpc52xx-psc.c   |   13 +---
 drivers/spi/spi-mpc52xx.c       |   14 +----
 drivers/spi/spi-nuc900.c        |   14 +----
 drivers/spi/spi-oc-tiny.c       |   13 +---
 drivers/spi/spi-omap2-mcspi.c   |    7 +-
 drivers/spi/spi-pl022.c         |  146 ++++++++++++++++++---------------------
 drivers/spi/spi-ppc4xx.c        |   15 +----
 drivers/spi/spi-s3c24xx.c       |   21 ++----
 drivers/spi/spi-sh-msiof.c      |   15 +----
 drivers/spi/spi-sh-sci.c        |   13 +---
 drivers/spi/spi-sh.c            |   15 +----
 drivers/spi/spi-stmp.c          |   13 +---
 drivers/spi/spi-tegra.c         |   17 +----
 drivers/spi/spi-ti-ssp.c        |   13 +---
 drivers/spi/spi-xilinx.c        |   13 +---
 drivers/tty/serial/of_serial.c  |   12 +---
 include/linux/platform_device.h |   17 +++++
 33 files changed, 231 insertions(+), 494 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
