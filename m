Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab2DMSQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:16:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43443 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2DMSQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:16:47 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 13 Apr 2012 12:16:26 -0600
X-Google-Sender-Auth: Iy320RthyskcV-0Ac0T4soD01BM
Message-ID: <CACxGe6t-YGz==WE3-0Kf3=6jjc6BSMN-8wepOBwJ2S0j5N0=xQ@mail.gmail.com>
Subject: [GIT PULL] SPI bug fixes needed on v3.4-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Simple set of bug fixes.  Please pull

g.

The following changes since commit f52b69f86e27903d6896ed5fa7cd280fec8de532:

  Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh
(2012-03-30 00:09:17 -0700)

are available in the git repository at:


  git://git.secretlab.ca/git/linux-2.6 tags/spi-for-linus

for you to fetch changes up to 39ec0d38141b198f94fd19c2bb10fd7c616510d2:

  spi/imx: prevent NULL pointer dereference in spi_imx_probe()
(2012-04-10 22:17:15 -0600)

----------------------------------------------------------------
SPI bug fixes on top of v3.4-rc2

Miscellaneous driver bug fixes.  No major changes in this branch.

----------------------------------------------------------------
Kenth Eriksson (1):
      spi/mpc83xx: fix NULL pdata dereference bug

Lothar Waßmann (1):
      spi/imx: prevent NULL pointer dereference in spi_imx_probe()

Shubhrajyoti D (1):
      spi/davinci: Fix DMA API usage in davinci

Uwe Kleine-König (1):
      spi/imx: mark base member in spi_imx_data as __iomem

Viresh Kumar (1):
      spi/pL022: include types.h to remove compilation warnings

 drivers/spi/spi-davinci.c  |    6 +++---
 drivers/spi/spi-fsl-spi.c  |    4 +++-
 drivers/spi/spi-imx.c      |   12 ++++++++----
 include/linux/amba/pl022.h |    2 ++
 4 files changed, 16 insertions(+), 8 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
