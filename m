Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1FHUir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:38:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57842 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1FHUiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:38:46 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 8 Jun 2011 14:38:26 -0600
X-Google-Sender-Auth: BKUVU0XR5rGpOuP3O90i1Gfaw8c
Message-ID: <BANLkTikmjG6oXHRMe=oZx3i6RhXdupBpLA@mail.gmail.com>
Subject: [GIT PULL] spi bug fixes for v3.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 spi/merge

Geert Uytterhoeven (1):
      spi/rtc-m41t93: Use spi_get_drvdata() for SPI devices

Govindraj.R (1):
      spi/omap2: fix uninitialized variable

 drivers/rtc/rtc-m41t93.c  |    2 +-
 drivers/spi/omap2_mcspi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
