Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1F0QQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:16:10 -0400
Received: from void.printf.net ([89.145.121.20]:46150 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1F0QQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:16:05 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.0-rc5
Date: Mon, 27 Jun 2011 12:15:54 -0400
Message-ID: <m2mxh3cksl.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive small regression fixes for MMC.  These have been tested in
linux-next.  Thanks.


The following changes since commit c11760c6d80ab6aa20e383cf378a7287305f591c:

  isofs: fix bh leak in isofs_fill_super() error case (2011-06-18 07:25:42 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Adrian Hunter (4):
      mmc: block: switch card to User Data Area when removing the block driver
      mmc: core: make erase timeout calculation allow for gated clock
      mmc: queue: append partition subname to queue thread name
      mmc: queue: bring discard_granularity/alignment into line with SCSI

Anand Gadiyar (1):
      mmc: omap_hsmmc: fix ocr mask usage

Chris Ball (1):
      mmc: vub300: fix null dereferences in error handling

Daniel Drake (1):
      mmc: sdio: reset card during power_restore

Guennadi Liakhovetski (3):
      mmc: sdhi: fix module unloading
      mmc: tmio: fix regression in TMIO_MMC_WRPROTECT_DISABLE handling
      mmc: sdhi: DMA slave ID 0 is invalid

James Hogan (1):
      mmc: cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS

Manoj Iyer (1):
      mmc: Add PCI fixup quirks for Ricoh 1180:e823 reader

Ohad Ben-Cohen (1):
      mmc: sdio: fix runtime PM path during driver removal

Per Forlin (1):
      mmc: omap_hsmmc: use original sg_len for dma_unmap_sg

Wanlong Gao (1):
      mmc: of_mmc_spi: add NO_IRQ define to of_mmc_spi.c

 drivers/misc/cb710/sgbuf2.c       |    2 +-
 drivers/mmc/card/block.c          |    5 +++-
 drivers/mmc/card/queue.c          |   15 +++++--------
 drivers/mmc/card/queue.h          |    3 +-
 drivers/mmc/core/core.c           |    2 +-
 drivers/mmc/core/sdio.c           |   39 +++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio_bus.c       |    2 +-
 drivers/mmc/host/of_mmc_spi.c     |    5 ++++
 drivers/mmc/host/omap_hsmmc.c     |    6 ++--
 drivers/mmc/host/sh_mobile_sdhi.c |    5 ++-
 drivers/mmc/host/tmio_mmc_pio.c   |    4 +-
 drivers/mmc/host/vub300.c         |   11 +++------
 drivers/pci/quirks.c              |    2 +
 include/linux/pci_ids.h           |    1 +
 14 files changed, 74 insertions(+), 28 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
