Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2FKPbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:31:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61246 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2FKPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca
Subject: [PATCH 00/14] Final (large) batch of Snowball Device Tree Enablement
Date: Mon, 11 Jun 2012 16:24:53 +0100
Message-Id: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully, this will be the last lot of enablement patches for Snowball.
The only thing to follow this patch-set is clean-ups and enablement of
drivers/power.

Some of these patches have been on the MLs before, but are yet
to be reviewed/SOB the correct people.

In-Reply-To: 
 arch/arm/boot/dts/db8500.dtsi      |   33 +++++++----
 arch/arm/mach-ux500/cpu-db8500.c   |    1 -
 drivers/i2c/busses/i2c-nomadik.c   |   40 ++++++++++++-
 drivers/input/misc/ab8500-ponkey.c |    6 ++
 drivers/mfd/Kconfig                |   11 +---
 drivers/mfd/ab8500-core.c          |  114 +++++++++++++++++++++---------------
 drivers/mfd/ab8500-gpadc.c         |    3 +-
 drivers/mfd/db8500-prcmu.c         |    7 ++-
 drivers/rtc/rtc-ab8500.c           |   10 +++-
 drivers/usb/otg/ab8500-usb.c       |    6 ++
 include/linux/mfd/abx500/ab8500.h  |    4 ++
 11 files changed, 159 insertions(+), 76 deletions(-)

