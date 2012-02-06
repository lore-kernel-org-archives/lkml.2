Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2BFG2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:28:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59920 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab2BFG2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:28:36 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 5 Feb 2012 23:28:15 -0700
X-Google-Sender-Auth: _MdJcXyai5DRtgR-f2rwanIhv9A
Message-ID: <CACxGe6uf6BpnHUFF7Svx_-C+ZGFop3T=TGGRi8kFQCgH56E4yA@mail.gmail.com>
Subject: [git pull] SPI changes for v3.3-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

A couple of minor SPI fixes.  Description in signed tag.  Please pull.

g.

The following changes since commit 23783f817bceedd6d4e549385e3f400ea64059e5:

  Merge tag 'pm-fixes-for-3.3-rc3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2012-02-04 15:21:39 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi-for-linus

Danny Kukawka (1):
      spi-topcliff-pch: rename pch_spi_pcidev to pch_spi_pcidev_driver

Sylwester Nawrocki (1):
      spi: Add spi-s3c64xx driver dependency on ARCH_EXYNOS4

 drivers/spi/Kconfig            |    2 +-
 drivers/spi/spi-topcliff-pch.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
