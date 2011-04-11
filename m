Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab1DKGqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 02:46:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59850 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab1DKGqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 02:46:21 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 10 Apr 2011 23:45:58 -0700
X-Google-Sender-Auth: fLAsQTM-cAKHcV6THNIhNU_NbQ4
Message-ID: <BANLkTikkwc=1UzwRv5OZazUy5q_hCdKNhg@mail.gmail.com>
Subject: [git pull] spi, dt and gpio bug fixes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.  Here are some bug fix commits.

g.

The following changes since commit 4263a2f1dad8c8e7ce2352a0cbc882c2b0c044a9:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
(2011-04-10 09:56:10 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/merge

Ben Dooks (1):
      gpio/pca953x: fix error handling path in probe() call

Grant Likely (1):
      Merge commit 'v2.6.39-rc2' into spi/merge

Ira W. Snyder (1):
      dt/fsldma: fix build warning caused by of_platform_device changes

Peter Tyser (2):
      gpio/ml_ioh_gpio: Fix output value of ioh_gpio_direction_output()
      gpio/pch_gpio: Fix output value of pch_gpio_direction_output()

Vasily Khoruzhick (1):
      spi: Fix race condition in stop_queue()

 drivers/dma/fsldma.c       |    2 +-
 drivers/gpio/ml_ioh_gpio.c |    1 +
 drivers/gpio/pca953x.c     |    5 +++--
 drivers/gpio/pch_gpio.c    |    1 +
 drivers/spi/amba-pl022.c   |    2 +-
 drivers/spi/dw_spi.c       |    2 +-
 drivers/spi/pxa2xx_spi.c   |    2 +-
 drivers/spi/spi_bfin5xx.c  |    2 +-
 8 files changed, 10 insertions(+), 7 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
