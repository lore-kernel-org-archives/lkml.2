Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2LMSPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:15:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46233 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LMSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:15:04 -0500
From: dromede@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, rdunlap@xenotime.net
Subject: [PATCH] Documentation: devres: add PHY get/put functions to list of supported calls
Date: Thu, 13 Dec 2012 19:14:54 +0100
Message-Id: <1355422494-11747-1-git-send-email-dromede@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marko Katic <dromede.gmail.com>


Signed-off-by: Marko Katic <dromede.gmail.com>
---
 Documentation/driver-model/devres.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 43cff70..db5e444 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -288,3 +288,7 @@ PINCTRL
 PWM
   devm_pwm_get()
   devm_pwm_put()
+
+PHY
+  devm_usb_get_phy()
+  devm_usb_put_phy()
-- 
1.7.10.4

