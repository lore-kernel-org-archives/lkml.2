Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2GRQtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:49:22 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:54114 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2GRQtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:49:19 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq387pErHR
X-RZG-CLASS-ID: mo00
From: olaf@aepfle.de
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] led: use correct name for /sys/devices/virtual/leds/ entries
Date: Wed, 18 Jul 2012 18:49:16 +0200
Message-Id: <1342630156-16432-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

Follow naming according to Documentation/leds/leds-class.txt:
LED Device Naming
Is currently of the form:
"devicename:colour:function"

Reported during openSuSE 11.1 testing.
https://bugzilla.novell.com/show_bug.cgi?&id=468350

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/drivers/leds/ledtrig-default-on.c b/drivers/leds/ledtrig-default-on.c
index a4ef54b..2efdd30 100644
--- a/drivers/leds/ledtrig-default-on.c
+++ b/drivers/leds/ledtrig-default-on.c
@@ -23,7 +23,7 @@ static void defon_trig_activate(struct led_classdev *led_cdev)
 }
 
 static struct led_trigger defon_led_trigger = {
-	.name     = "default-on",
+	.name     = "default::on",
 	.activate = defon_trig_activate,
 };
 
-- 
1.7.10.4

