Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0HWJV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:21:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab0HWJV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:21:58 -0400
From: Thomas Weber <weber@corscience.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Weber <weber@corscience.de>
Subject: [PATCH] Fix typo in Kconfig help text
Date: Mon, 23 Aug 2010 11:20:34 +0200
Message-Id: <1282555234-3196-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.2
X-Provags-ID: V02:K0:M+0vmA7v5DYdulke/etVv9cx3AsOg+lAAz6wF17nMwb
 QtysZ8RLsUC1XZ9gOih3o32Ik/+Bl5r7nGeXau64QGLHgeU0IW
 Q/3o1NLhaZrcWpHsqZSlf/M+KyPK2mmTPCgmuuR3mJSB05Dwb/
 j9Bhk1dXvSqhYxKQ38sDXrtHoUW2W99Z7LFAHjdFDSCbkjXaky
 ECbWLAbKTfzsDxeZ7FhxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the name of the sensor: BMP086 => BMP085

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0b591b6..9df5b75 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -385,7 +385,7 @@ config BMP085
 	depends on I2C && SYSFS
 	help
 	  If you say yes here you get support for the Bosch Sensortec
-	  BMP086 digital pressure sensor.
+	  BMP085 digital pressure sensor.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called bmp085.
-- 
1.7.2

