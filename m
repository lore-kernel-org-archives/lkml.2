Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2CEQMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:12:43 -0500
Received: from void.printf.net ([89.145.121.20]:36903 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab2CEQMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:12:41 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.3
Date: Mon, 05 Mar 2012 11:12:25 -0500
Message-ID: <m2hay3jac6.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive MMC fixes for 3.3.  I've signed an "mmc-fixes-for-3.3" tag.
There are no merge conflicts, and the patches have been tested in
linux-next.  Thanks.

The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:

  Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for you to fetch changes up to e7747475b61fdc2a4a412475a9d64d8c309916e3:

  mmc: core: Fixup suspend/resume issues for UHS-I cards (2012-03-04 12:25:15 -0500)

----------------------------------------------------------------
MMC fixes for 3.3:
* atmel-mci: oops fix against regression introduced in 3.2
* core: power saving regression fix against 3.3-rc1
* core: suspend/resume fix for UHS-I cards
* esdhc-imx: MMC card regression fix against 3.0
* mmci: oops fix for ARM systems with large (64k) pages
* MAINTAINERS update for atmel-mci.

----------------------------------------------------------------
Guennadi Liakhovetski (1):
      mmc: core: fix regression: set default clock gating delay to 0

Ludovic Desroches (1):
      mmc: atmel-mci: don't use dma features when using DMA with no chan available

Nicolas Ferre (1):
      MAINTAINERS: hand over atmel-mci (sd/mmc interface)

Sascha Hauer (1):
      mmc: sdhci-esdhc-imx: fix for mmc cards on i.MX5

Ulf Hansson (1):
      mmc: core: Fixup suspend/resume issues for UHS-I cards

Will Deacon (1):
      mmc: mmci: reduce max_blk_count to avoid overflowing max_req_size

 MAINTAINERS                        |    4 ++--
 drivers/mmc/core/core.c            |    3 +++
 drivers/mmc/core/host.c            |    4 ++--
 drivers/mmc/core/mmc.c             |    3 +++
 drivers/mmc/core/sd.c              |    8 +++-----
 drivers/mmc/core/sdio.c            |    8 ++++++++
 drivers/mmc/host/atmel-mci.c       |   21 ++++++++++-----------
 drivers/mmc/host/mmci.c            |    7 ++++---
 drivers/mmc/host/sdhci-esdhc-imx.c |    5 +++--
 9 files changed, 38 insertions(+), 25 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
