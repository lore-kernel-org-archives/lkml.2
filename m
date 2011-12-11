Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1LKSky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 13:40:54 -0500
Received: from void.printf.net ([89.145.121.20]:43216 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab1LKSkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 13:40:52 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.2-rc6
Date: Sun, 11 Dec 2011 13:40:38 -0500
Message-ID: <m2fwgrost5.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive small regression fixes for MMC.  These have been tested in
linux-next, and there are no merge conflicts.  Thanks.


The following changes since commit 77a7300abad7fe01891b400e88d746f97307ee5a:

  of/irq: Get rid of NO_IRQ usage (2011-12-07 09:06:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to 49df78074963c97e25debc3c67b72f059111607d:

  mmc: core: Fix deadlock when the CONFIG_MMC_UNSAFE_RESUME is not defined (2011-12-10 16:18:39 -0500)

- ----------------------------------------------------------------
Chris Ball (1):
      mmc: Add module.h include to sdhci-cns3xxx.c

Girish K S (2):
      mmc: core: Fix setting power notify state variable for non-eMMC
      mmc: core: Fix power_off_notify during suspend

Guennadi Liakhovetski (2):
      mmc: sh_mmcif: fix clock gating on platforms with a .down_pwr() method
      mmc: tmio: fix clock gating on platforms with a .set_pwr() method

Kyungmin Park (1):
      mmc: core: Fix typo at mmc_card_sleep

Mark Brown (1):
      mmc: sdhci-s3c: Remove old and misprototyped suspend operations

Per Forlin (1):
      mmc: omap_hsmmc: DMA unmap only once in case of MMC error

Sascha Hauer (1):
      mmc: mxcmmc: fix falling back to PIO

Stefan Nilsson XK (1):
      mmc: core: Add quirk for long data read time

Sujit Reddy Thumma (1):
      mmc: core: Fix deadlock when the CONFIG_MMC_UNSAFE_RESUME is not defined

 drivers/mmc/card/block.c         |    8 +++
 drivers/mmc/core/core.c          |   98 +++++++++++++++++++++++++-------------
 drivers/mmc/core/mmc.c           |   12 +++--
 drivers/mmc/host/mxcmmc.c        |    1 +
 drivers/mmc/host/omap_hsmmc.c    |    7 ++-
 drivers/mmc/host/sdhci-cns3xxx.c |    1 +
 drivers/mmc/host/sdhci-s3c.c     |    2 -
 drivers/mmc/host/sh_mmcif.c      |    2 +-
 drivers/mmc/host/tmio_mmc_pio.c  |    2 +-
 include/linux/mmc/card.h         |    6 ++
 10 files changed, 95 insertions(+), 44 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO5PQXAAoJEHNBYZ7TNxYM8LgQAN+MjIovCGmoVeNQF6lc88OO
GTrxRwCNmrgltc9Zd5Ks3Eo6kCnMo2fupH1qjWBw1nNZ0VvBm0m51NcjCbBGY9oG
nVmDrLMkBdUkLWE2pPbEWeT3dBHARLM37KQu2wY9d82Vf4G8KabioBd6/amfufGo
zcfQrhaPc8qo/oolJMqm1S1/0sK5dkljeBE5vfJTWnWioGIUPPwJDKn9XfBPNkS4
zY712rdaVYIG3IoXu7Bl+0Cjbz3m53wq+p/8dIUzv3eNStBpvx5YtvtCFwq5ZxXG
uEZ40i5DmT5SNsbhjOUs4Lt6nng9cgrN8cHPNRxvtgJtCOpsij4V9Aubst/CBGXm
sKFJ5TD8TnN7t/EnmyNBX1GYC+9s2sOxmte53nSn7b4vJZHvUPmyDQJhIDfp0x5F
MkZOkwA89kpbVEYRKXLamXP4RDuDjb04lv9EuoKyPrTC1AR8AcZboOttDgQhIygW
9Baw2P/JYxJGkF2R+IbsYrFiOUzEABcYXpshUC0w10vtUuVB6MkPptoPAVFFwc7X
naz5942e8XNA5pOagoqYvc6ryrByK52tIZ0zI7+dht6sP0shJpvdbimiHNXcefcy
Zxdr9FyVk/fFh5dEQ5eTjfprtDXksC9aXHVdfjVES2RXVVRfamzPtbrDmKReVEWZ
ldes9pqD/xEZ0IDcjhUL
=MUDZ
-----END PGP SIGNATURE-----

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
