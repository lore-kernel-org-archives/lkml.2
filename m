Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0HCHCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:02:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43004 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab0HCHCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:02:15 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 3 Aug 2010 01:01:51 -0600
X-Google-Sender-Auth: WQakqaU69y30f0q9QUBBy-bWlB8
Message-ID: <AANLkTimMR6_zuA8BRy+ZcDQS0o7N5h4u9PikoqAhxisO@mail.gmail.com>
Subject: [git pull] spi tree
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kevin Wells <kevin.wells@nxp.com>, Ernst Schwab <eschwab@online.de>,
        Cory Maccarrone <darkstar6262@gmail.com>,
        Brian Niebuhr <bniebuhr3@gmail.com>,
        Anatolij Gustschin <agust@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the spi driver changes queued up for 2.6.36.

Cheers,
g.

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Anatolij Gustschin (1):
      spi/mpc5121: change annotations for probe and remove functions

Brian Niebuhr (1):
      spi/bitbang: reinitialize transfer parameters for every message

Cory Maccarrone (1):
      SPI100k: Fix 8-bit and RX-only transfers

Ernst Schwab (2):
      spi/mmc_spi: SPI bus locking API, using mutex
      spi/mmc_spi: mmc_spi adaptations for SPI bus locking API

Grant Likely (1):
      Merge commit 'v2.6.35-rc6' into spi/test

Kevin Wells (1):
      spi/amba_pl022: Fix probe and remove hook section annotations.

Marek Szyprowski (2):
      spi/bitbang: add support for SPI_MASTER_NO_{TX, RX} modes
      spi/spi-gpio: add support for controllers without MISO or MOSI pin

 drivers/mmc/host/mmc_spi.c     |   59 ++---------
 drivers/spi/amba-pl022.c       |    6 +-
 drivers/spi/mpc512x_psc_spi.c  |   16 ++--
 drivers/spi/omap_spi_100k.c    |   23 ++--
 drivers/spi/spi.c              |  225 ++++++++++++++++++++++++++++++++++------
 drivers/spi/spi_bitbang.c      |    9 +-
 drivers/spi/spi_bitbang_txrx.h |   16 ++-
 drivers/spi/spi_butterfly.c    |    2 +-
 drivers/spi/spi_gpio.c         |  109 +++++++++++++++----
 drivers/spi/spi_lm70llp.c      |    2 +-
 drivers/spi/spi_s3c24xx_gpio.c |    8 +-
 drivers/spi/spi_sh_sci.c       |    8 +-
 include/linux/spi/spi.h        |   12 ++
 include/linux/spi/spi_gpio.h   |    5 +
 14 files changed, 353 insertions(+), 147 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
