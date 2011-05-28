Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1E1GGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:06:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36172 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1E1GGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:06:37 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 28 May 2011 00:06:11 -0600
X-Google-Sender-Auth: swMdR3FLGfAGeIBILfUP4u3shPI
Message-ID: <BANLkTi=2f2xVZjtwENpmaWbDEvEXKaPMKQ@mail.gmail.com>
Subject: [GIT PULL] a couple more SPI changes
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two more SPI changes for you, a new driver and a bug fix.

Thanks,
g.

The following changes since commit 29a6ccca3869bbe33879dae0cd7df2a1559eff54:

  Merge git://git.infradead.org/mtd-2.6 (2011-05-27 20:06:53 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/next

Axel Lin (1):
      spi/tle620x: add missing device_remove_file()

Cliff Cai (1):
      spi/spi_bfin_sport: new driver for a SPI bus via the Blackfin
SPORT peripheral

 drivers/spi/Kconfig          |    9 +
 drivers/spi/Makefile         |    1 +
 drivers/spi/spi_bfin_sport.c |  952 ++++++++++++++++++++++++++++++++++++++++++
 drivers/spi/tle62x0.c        |    3 +-
 4 files changed, 964 insertions(+), 1 deletions(-)
 create mode 100644 drivers/spi/spi_bfin_sport.c


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
