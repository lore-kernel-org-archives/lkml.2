Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab0LXJob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:44:31 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:54961 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0LXJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:44:30 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 24 Dec 2010 02:44:09 -0700
X-Google-Sender-Auth: 8LCjH6zS_vndGpOTSvA03rVPcbg
Message-ID: <AANLkTi=TErzg+_2u1sPCpOepAGnzv6KNT6uPT_KSFLZ=@mail.gmail.com>
Subject: [git pull] bug fixes for 2.6.37
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A handful of last minute bug fix commits.

g.

The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:

  Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 merge

David Daney (1):
      of/i2c: Fix request module by alias

Mingkai Hu (2):
      spi/fsl_espi: change the read behaviour of the SPIRF
      spi/fsl_espi: fix wrong setting of the address in the command buffer

Wolfram Sang (2):
      powerpc/mpc5200: include fs.h in mpc52xx_gpt.c
      spi/mpc52xx-spi: fix annotation for remove()-pointer

 arch/powerpc/platforms/52xx/mpc52xx_gpt.c |    1 +
 drivers/of/of_i2c.c                       |    2 +-
 drivers/spi/mpc52xx_spi.c                 |    2 +-
 drivers/spi/spi_fsl_espi.c                |   35 ++++++++++++++++++++--------
 4 files changed, 28 insertions(+), 12 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
