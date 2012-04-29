Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2D2KHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 06:07:14 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33654 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2D2KHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 06:07:12 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martyn Welch <martyn.welch@ge.com>,
        Gerard Snitselaar <dev@snitselaar.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] staging/vme: Remove version.h include
Date: Sun, 29 Apr 2012 16:07:02 +0600
Message-Id: <1335694022-8819-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are version.h includes that are not needed as make versioncheck reports.
files:
1. drivers/staging/vme/devices/vme_pio2_core.c
2. drivers/staging/vme/devices/vme_pio2_gpio.c

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_core.c |    1 -
 drivers/staging/vme/devices/vme_pio2_gpio.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 573c800..dd8012f 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -10,7 +10,6 @@
  * option) any later version.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
diff --git a/drivers/staging/vme/devices/vme_pio2_gpio.c b/drivers/staging/vme/devices/vme_pio2_gpio.c
index 8584849..5313c2e 100644
--- a/drivers/staging/vme/devices/vme_pio2_gpio.c
+++ b/drivers/staging/vme/devices/vme_pio2_gpio.c
@@ -10,7 +10,6 @@
  * option) any later version.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
-- 
1.7.9.5

