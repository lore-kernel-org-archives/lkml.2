Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0JQGUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 02:20:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37988 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab0JQGUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 02:20:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] ad525x_dpot: default to off
Date: Sun, 17 Oct 2010 02:22:25 -0400
Message-Id: <1287296545-21822-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

No reason for this to be enabled by default.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b743312..7691f89 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -16,6 +16,7 @@ if MISC_DEVICES
 config AD525X_DPOT
 	tristate "Analog Devices Digital Potentiometers"
 	depends on (I2C || SPI) && SYSFS
+	default n
 	help
 	  If you say yes here, you get support for the Analog Devices
 	  AD5258, AD5259, AD5251, AD5252, AD5253, AD5254, AD5255
-- 
1.7.3.1

