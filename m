Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935537Ab1ETJue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:50:34 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:47485 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935479Ab1ETJuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:50:32 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH 0/3] remove mach-mxs gpio driver
Date: Fri, 20 May 2011 17:57:23 +0800
Message-Id: <1305885446-27404-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is to remove mach-mxs gpio driver and use gpio-mxs
driver under drivers/gpio.

Shawn Guo (3):
      ARM: mxs: remove gpio driver from mach-mxs
      ARM: mxs: add gpio-mxs platform devices
      ARM: mxs: select GPIO_MXS for i.MX23 and i.MX28

 arch/arm/mach-mxs/Kconfig                     |    2 +
 arch/arm/mach-mxs/Makefile                    |    2 +-
 arch/arm/mach-mxs/devices/Makefile            |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c |   92 +++++++
 arch/arm/mach-mxs/gpio.c                      |  331 -------------------------
 arch/arm/mach-mxs/gpio.h                      |   34 ---
 arch/arm/mach-mxs/mach-mx28evk.c              |    1 -
 arch/arm/mach-mxs/mm-mx23.c                   |    1 -
 arch/arm/mach-mxs/mm-mx28.c                   |    1 -
 9 files changed, 96 insertions(+), 369 deletions(-)

Regards,
Shawn
