Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2DREeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 00:34:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35957 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2DREeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 00:34:44 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>
Subject: [PATCH 12/12] drivers: staging: vme: devices: Remove unneeded include version.h
Date: Wed, 18 Apr 2012 01:30:12 -0300
Message-Id: <1334723412-5034-13-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
References: <1334723412-5034-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The output of "make versioncheck" told us that:

drivers/staging/vme/devices/vme_pio2_core.c: 13 linux/version.h not needed.
drivers/staging/vme/devices/vme_pio2_gpio.c: 13 linux/version.h not needed.

If we take a look at these files, we will agree to remove it.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <devel@driverdev.osuosl.org>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/vme/devices/vme_pio2_core.c |    1 -
 drivers/staging/vme/devices/vme_pio2_gpio.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

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
1.7.7.6

