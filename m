Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1HNTHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:07:31 -0400
Received: from void.printf.net ([89.145.121.20]:34755 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1HNTH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:07:27 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.1-rc2
Date: Sun, 14 Aug 2011 15:07:10 -0400
Message-ID: <m239h3olr5.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for a small set of MMC fixes and cleanups.  There are currently no merge
conflicts, and the patches have been tested in linux-next.  Thanks.


The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Aaron Lu (1):
      mmc: sdhci: fix retuning timer wrongly deleted in sdhci_tasklet_finish

Andy Shevchenko (5):
      mmc: mmc_test: avoid stalled file in debugfs
      mmc: Revert "mmc: sdhci: Fix SDHCI_QUIRK_TIMEOUT_USES_SDCLK"
      mmc: sdhci: check host->clock before using it as a denominator
      mmc: sdhci: move timeout_clk calculation farther down
      mmc: sdhci: use f_max instead of host->clock for timeouts

Axel Lin (1):
      mmc: tmio: eliminate unused variable 'mmc' warning

Jaehoon Chung (3):
      mmc: sdhci-s3c: add BROKEN_ADMA_ZEROLEN_DESC quirk
      mmc: core: use defined R1_STATE_PRG macro for card status
      mmc: remove unused "ddr" parameter in struct mmc_ios

Kyungmin Park (1):
      mmc: core: Detect eMMC v4.5 ext_csd entries

Mark Brown (1):
      mmc: sdhci-s3c: Fix build for header change

Michał Mirosław (1):
      mmc: cb710: fix possible pci_dev leak in cb710_pci_configure()

Philip Rakity (1):
      mmc: sdhci: pxav3: controller needs 32 bit ADMA addressing

Seungwon Jeon (1):
      mmc: dw_mmc: Fix DDR mode support.

Shashidhar Hiremath (1):
      mmc: dw_mmc: Fix mask in IDMAC_SET_BUFFER1_SIZE macro

Tony Lin (1):
      mmc: esdhc-imx: fix card interrupt loss on freescale eSDHC

 drivers/misc/cb710/core.c          |    3 +-
 drivers/mmc/card/mmc_test.c        |   58 +++++++++++++++++++----------------
 drivers/mmc/core/core.c            |    2 +-
 drivers/mmc/core/mmc.c             |    2 +-
 drivers/mmc/core/mmc_ops.c         |    2 +-
 drivers/mmc/host/dw_mmc.c          |    6 ++--
 drivers/mmc/host/sdhci-esdhc-imx.c |   40 +++++++++++++++++++-----
 drivers/mmc/host/sdhci-pxav3.c     |    3 +-
 drivers/mmc/host/sdhci-s3c.c       |    4 ++
 drivers/mmc/host/sdhci.c           |   53 +++++++++++++++------------------
 drivers/mmc/host/tmio_mmc.c        |    2 -
 include/linux/mmc/host.h           |    2 -
 12 files changed, 100 insertions(+), 77 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
