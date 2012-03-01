Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030474Ab2CABbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:31:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56942 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965191Ab2CABba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:31:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.135.137 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330565485.5373.3.camel@phoenix>
Subject: [PATCH] mfd: Fix a typo in MFD_MAX8997 Kconfig entry
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 01 Mar 2012 09:31:25 +0800
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
index f3951d3..cd6d1e0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -423,7 +423,7 @@ config MFD_MAX8997
 	depends on I2C=y && GENERIC_HARDIRQS
 	select MFD_CORE
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8998/8966.
+	  Say yes here to support for Maxim Semiconductor MAX8997/8966.
 	  This is a Power Management IC with RTC, Flash, Fuel Gauge, Haptic,
 	  MUIC controls on chip.
 	  This driver provides common support for accessing the device;
-- 
1.7.5.4



