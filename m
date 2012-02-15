Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2BOIFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 03:05:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59770 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2BOIF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 03:05:28 -0500
Message-ID: <1329293124.13730.2.camel@phoenix>
Subject: [PATCH v2] mfd: Fix typo for TPS65912
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Margarita Olaya <magi@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 15 Feb 2012 16:05:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index bd60ce0..b725d0b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -171,7 +171,7 @@ config MFD_TPS65912
 	depends on GPIOLIB
 
 config MFD_TPS65912_I2C
-	bool "TPS95612 Power Management chip with I2C"
+	bool "TPS65912 Power Management chip with I2C"
 	select MFD_CORE
 	select MFD_TPS65912
 	depends on I2C=y && GPIOLIB
-- 
1.7.5.4



