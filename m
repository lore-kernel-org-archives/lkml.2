Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1ECKVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:21:04 -0400
Received: from void.printf.net ([89.145.121.20]:46311 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1ECKVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:21:02 -0400
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [GIT PULL] MMC fixes for 2.6.39-rc6
Date: Tue, 03 May 2011 06:24:04 -0400
Message-ID: <m31v0gqdyz.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

to receive seven small fixes for MMC.  These have been tested in
linux-next.  Thanks.

The following changes since commit e8dad69408a9812d6bb42d03e74d2c314534a4fa:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../jejb/parisc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Ben Dooks (1):
      mmc: sdhci: Check mrq->cmd in sdhci_tasklet_finish

Chris Ball (2):
      mmc: sdhci-pci: Fix error case in sdhci_pci_probe_slot()
      mmc: sdhci: Check mrq != NULL in sdhci_tasklet_finish

Guennadi Liakhovetski (2):
      mmc: fix a race between card-detect rescan and clock-gate work instances
      mmc: tmio: fix .set_ios(MMC_POWER_UP) handling

Michael Buesch (1):
      mmc: omap: Fix possible NULL pointer deref

Michał Mirosław (1):
      mmc: core: mmc_add_card(): fix missing break in switch statement

 drivers/mmc/core/bus.c          |    1 +
 drivers/mmc/core/host.c         |    9 ++++-----
 drivers/mmc/host/omap.c         |    2 +-
 drivers/mmc/host/sdhci-pci.c    |    1 +
 drivers/mmc/host/sdhci.c        |    9 ++++++++-
 drivers/mmc/host/tmio_mmc_pio.c |   10 +++++-----
 include/linux/mmc/host.h        |    1 -
 7 files changed, 20 insertions(+), 13 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
