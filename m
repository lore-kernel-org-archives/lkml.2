Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1FEPuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 11:50:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61490 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab1FEPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 11:50:51 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: [PATCH v4 0/3] Move Freescale MXS gpio driver into drivers/gpio
Date: Sun,  5 Jun 2011 23:59:02 +0800
Message-Id: <1307289545-6993-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set moves Freescale MXS gpio driver from mach-mxs into
drivers/gpio.

Changes since v3:
 * Reorganize the patch set per Grant's comments

Grant Likely (1):
      gpio/mxs: Move Freescale mxs gpio driver to drivers/gpio

Shawn Guo (2):
      gpio/mxs: Change gpio-mxs into an upstanding gpio driver
      gpio/mxs: Remove the use of gpio-mxs.h

 arch/arm/mach-mxs/Makefile                         |    2 +-
 arch/arm/mach-mxs/devices.c                        |   11 +
 arch/arm/mach-mxs/devices/Makefile                 |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |   53 +++++
 arch/arm/mach-mxs/gpio.h                           |   34 ---
 arch/arm/mach-mxs/include/mach/devices-common.h    |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                   |    1 -
 arch/arm/mach-mxs/mm-mx23.c                        |    1 -
 arch/arm/mach-mxs/mm-mx28.c                        |    1 -
 drivers/gpio/Kconfig                               |    4 +
 drivers/gpio/Makefile                              |    1 +
 .../arm/mach-mxs/gpio.c => drivers/gpio/gpio-mxs.c |  227 ++++++++++++--------
 12 files changed, 206 insertions(+), 132 deletions(-)
