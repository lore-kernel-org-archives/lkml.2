Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab1IIADR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:03:17 -0400
Received: from void.printf.net ([89.145.121.20]:41704 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756522Ab1IIADO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:03:14 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 3.1-rc6
Date: Thu, 08 Sep 2011 20:03:04 -0400
Message-ID: <m27h5i4m6f.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://dev.laptop.org/users/cjb/mmc for-linus

to receive small regression fixes for MMC.  These have been tested in
linux-next, and there are no merge conflicts.  Thanks.


The following changes since commit fcb8ce5cfe30ca9ca5c9a79cdfe26d1993e65e0c:

  Linux 3.1-rc3 (2011-08-22 11:42:53 -0700)

are available in the git repository at:
  git://dev.laptop.org/users/cjb/mmc for-linus

Girish K S (1):
      mmc: sdhci-s3c: Fix mmc card I/O problem

Mika Westerberg (3):
      mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
      mmc: core: prevent aggressive clock gating racing with ios updates
      mmc: core: use non-reentrant workqueue for clock gating

Shawn Guo (1):
      mmc: sdhci-esdhc-imx: add missing inclusion of linux/module.h

Simon Horman (1):
      mmc: sdhi: initialise mmc_data->flags before use

Subhash Jadavani (1):
      mmc: sd: UHS-I bus speed should be set last in UHS initialization

 drivers/mmc/core/core.c            |   35 ++++++++++++++--
 drivers/mmc/core/host.c            |   12 +++---
 drivers/mmc/core/host.h            |    8 ++--
 drivers/mmc/core/sd.c              |   81 +++++++++++++++++++++++------------
 drivers/mmc/host/sdhci-esdhc-imx.c |    1 +
 drivers/mmc/host/sdhci-s3c.c       |    2 +
 drivers/mmc/host/sh_mobile_sdhi.c  |    4 +-
 7 files changed, 99 insertions(+), 44 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
