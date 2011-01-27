Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1A0A4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:56:34 -0500
Received: from void.printf.net ([89.145.121.20]:46444 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1A0A4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:56:33 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: MMC fixes for 2.6.38-rc3
Date: Wed, 26 Jan 2011 20:00:11 -0500
Message-ID: <m3lj27i2jo.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

for five small fixes to MMC host controller drivers.  These have been
tested in linux-next.  Thanks.

The following changes since commit 6663050edd9c2e8b1e1f55c09459144d84c045f0:

  Merge branch 'fixes' of master.kernel.org:/home/rmk/linux-2.6-arm (2011-01-26 09:04:18 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git for-linus

Jaehoon Chung (1):
      mmc: sdhci-s3c: add platform_8bit_width() hook

Jamie Iles (1):
      mmc: jz4740: don't treat NULL clk as an error

Jesper Juhl (1):
      mmc: ushc: Remove duplicate include of usb.h

Russell King - ARM Linux (1):
      mmc: mmci: don't read command response when invalid

Sonic Zhang (1):
      mmc: bfin_sdh: fix alloc size for private data

 drivers/mmc/host/bfin_sdh.c   |    2 +-
 drivers/mmc/host/jz4740_mmc.c |    5 +++--
 drivers/mmc/host/mmci.c       |   10 +++++-----
 drivers/mmc/host/sdhci-s3c.c  |   36 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/ushc.c       |    1 -
 5 files changed, 45 insertions(+), 9 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
