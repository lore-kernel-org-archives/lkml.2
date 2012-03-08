Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab2CHScL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:32:11 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57670 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184Ab2CHScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:32:08 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 8 Mar 2012 11:31:48 -0700
X-Google-Sender-Auth: WrLvBeadLs7D8M8rEtF1OAsgGMo
Message-ID: <CACxGe6tUg9ahP=9XE3KJQA-UJtfyT3a_Gb3fU-2mC53DJe1KAg@mail.gmail.com>
Subject: [git pull] spi section mismatch bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's one more bug fix for spi.

The following changes since commit d65b4e98d7ea3038b767b70fe8be959b2913f16d:

  Linux 3.3-rc3 (2012-02-08 19:21:53 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi-for-linus

for you to fetch changes up to a5ab6291b1fc73e0dc71caf2eaa0de1de7b11aaa:

  Fix section mismatch in spi-pl022.c (2012-02-13 11:57:58 -0700)

----------------------------------------------------------------
SPI section mismatch bug fix for v3.3-rc3

Russell King (1):
      Fix section mismatch in spi-pl022.c

Minor fix for pl022_dma_probe() function which was put in the wrong section.

----------------------------------------------------------------
Russell King (1):
      Fix section mismatch in spi-pl022.c

 drivers/spi/spi-pl022.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
