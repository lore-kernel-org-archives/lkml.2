Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab1ALJN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 04:13:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62807 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1ALJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 04:13:24 -0500
From: Thomas Weber <weber@corscience.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP: Enable Sysrq on serial console
Date: Wed, 12 Jan 2011 10:10:32 +0100
Message-Id: <1294823432-3969-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc1
X-Provags-ID: V02:K0:+kd+GAnIURUjshN/4D6Ps8pInd5MVYmv2GyljLtPNba
 vRqEwMGKR0MTF1a9QyGRqiKNjt+skpuxRrFR6fdBsbBO1MnKyo
 vmsRGmb2Kh7gjZRMCny/2ZgtaZFDGrs5fUIm3H/GsNyPAzEdMO
 9nspkhS3Qk1OoC8Jcc9gIhBIJH0D/TeSn6X8ETsqTA4WrtTTrB
 XpOxvN0F+aVRn4ngsV8vQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SUPPORT_SYSRQ must be defined to enable handling of sysrq character.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/serial/omap-serial.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
index 1201eff..907be9b 100644
--- a/drivers/serial/omap-serial.c
+++ b/drivers/serial/omap-serial.c
@@ -20,6 +20,10 @@
  * this driver as required for the omap-platform.
  */
 
+#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
+#define SUPPORT_SYSRQ
+#endif
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/console.h>
-- 
1.7.4.rc1

