Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab1EYQ1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:27:40 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:39601 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194Ab1EYQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:27:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Carlos Chinea <carlos.chinea@nokia.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>
Subject: [PATCH 0/2] Support for the ST-Ericsson HSI controller
Date: Wed, 25 May 2011 18:27:19 +0200
Message-ID: <1306340839-31331-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Hi Carlos,

here is the pending patch to add support for ST-Ericssons HSI controller
in your new HSI subsystem.

It would be great if you could carry this as part of the HSI patchset until
it gets merged so you have full control over it, but I think we need to
split out the <mash/hsi.h> file from the second patch and put it into
the hsi include dir first for that.

Anyway, take it as a first sign of life and a review opportunity.

Pawel Szyszuk (2):
  HSI: add ST-E HSI controller
  mach-ux500: platform data for ST-E HSI controller

 arch/arm/mach-ux500/board-mop500-pins.c    |   10 +
 arch/arm/mach-ux500/board-mop500.c         |   65 ++
 arch/arm/mach-ux500/clock.c                |    8 +-
 arch/arm/mach-ux500/devices-db8500.c       |  118 +++
 arch/arm/mach-ux500/include/mach/devices.h |    1 +
 arch/arm/mach-ux500/include/mach/hsi.h     |  122 +++
 drivers/hsi/controllers/Kconfig            |   10 +
 drivers/hsi/controllers/Makefile           |    1 +
 drivers/hsi/controllers/ste_hsi.c          | 1536 ++++++++++++++++++++++++++++
 9 files changed, 1867 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-ux500/include/mach/hsi.h
 create mode 100644 drivers/hsi/controllers/ste_hsi.c

-- 
1.7.3.2

