Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab0F2KQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:47959 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab0F2KQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WvgRCrQEwXmbmxX2tFra00j3uQRgsjjAjJthPl+rAlSYMYbkJesG9cUx+0h6MftWY7
         bSGyeKSYXf5WPSPUDNRkoOUUTOx26gYe6HUS0Y+VXO3aqbe3Zw+DZwom2KdJyZgAsv48
         BLuOAnLKncMhC08NAGB9TOdOXzG3kvGnLUGF8=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Henk de Groot <pe1dnn@amsat.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] wl_profile: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:33 +0400
Message-Id: <1277806594-31554-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/wlags49_h2/wl_profile.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
index 292d579..7a1337d 100644
--- a/drivers/staging/wlags49_h2/wl_profile.c
+++ b/drivers/staging/wlags49_h2/wl_profile.c
@@ -169,7 +169,7 @@ void parse_config(struct net_device *dev)
 	DBG_ENTER(DbgInfo);
 
 	/* Get the wavelan specific info for this device */
-	wvlan_config = (struct wl_private *)dev->priv;
+	wvlan_config = dev->priv;
 	if (wvlan_config == NULL) {
 		DBG_ERROR(DbgInfo, "Wavelan specific info struct not present?\n");
 		return;
-- 
1.7.0.4

