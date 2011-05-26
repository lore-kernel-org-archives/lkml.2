Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1EZGt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:49:58 -0400
Received: from mail.active-venture.com ([67.228.131.195]:51915 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab1EZGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:49:57 -0400
X-Virus-Scan: Scanned by ClamAV 0.94.2 (no viruses);
  Thu, 26 May 2011 01:49:56 -0500
X-Originating-IP: 68.125.166.242
From: Guenter Roeck <linux@roeck-us.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] mfd: (wl1273-core) Remove unused variable
Date: Wed, 25 May 2011 23:50:06 -0700
Message-Id: <1306392606-5949-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following build warning:

drivers/mfd/wl1273-core.c: In function wl1273_fm_set_volume:
drivers/mfd/wl1273-core.c:156: warning: unused variable var

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/mfd/wl1273-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index 04914f2..37af778 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -153,7 +153,6 @@ out:
  */
 static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
 {
-	u16 val;
 	int r;
 
 	if (volume > WL1273_MAX_VOLUME)
-- 
1.7.1

