Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1LIUcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:32:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51649 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LIUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:32:47 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [GIT PULL] spi updates for Linux 3.2
Date: Fri,  9 Dec 2011 21:32:31 +0100
Message-Id: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following spi updates for 3.2 which I collected on Grant's
behalf while he is on his sabbatical. These updates include three build fixes
and one section mismatch removal. I don't know if you trust our git-server, so
I attach the patches as a series as well, trivial as they are.

Thanks,

   Wolfram

The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:

  Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)

are available in the git repository at:
  git://git.pengutronix.de/git/wsa/linux-2.6.git spi/for-3.2

Axel Lin (1):
  spi/nuc900: Include linux/module.h

Gabor Juhos (1):
  spi/ath79: fix compile error due to missing include

Jiri Slaby (1):
  spi/fsl-espi: disable CONFIG_SPI_FSL_ESPI=m build

Manuel Lauss (1):
  spi/gpio: fix section mismatch warning

 drivers/spi/Kconfig      |    4 ++--
 drivers/spi/spi-ath79.c  |    1 +
 drivers/spi/spi-gpio.c   |    4 ++--
 drivers/spi/spi-nuc900.c |    1 +
 4 files changed, 6 insertions(+), 4 deletions(-)

-- 
1.7.2.5

