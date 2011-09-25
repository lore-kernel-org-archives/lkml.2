Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1IYHj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:39:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36496 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1IYHjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:39:05 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 3/4] staging: wlags49_h2: Declare support for WEXT 21
Date: Sun, 25 Sep 2011 08:30:20 +0100
Message-Id: <1316935821-6980-4-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
References: <1316935821-6980-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WEXT changes between versions 15 and 21 have been taken care of,
so update the declared support.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/wl_version.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_version.h b/drivers/staging/wlags49_h2/wl_version.h
index 872d085..a68159a 100644
--- a/drivers/staging/wlags49_h2/wl_version.h
+++ b/drivers/staging/wlags49_h2/wl_version.h
@@ -144,7 +144,8 @@ err: define bus type;
 							" for " BUS_TYPE ", " 											   	 \
 							MODULE_DATE " by " VENDOR_NAME
 
-#define WIRELESS_SUPPORT    15  // The version of wireless extensions we support
+/* The version of wireless extensions we support */
+#define WIRELESS_SUPPORT    21
 
 //#define DBG_MOD_NAME         DRIVER_NAME ":" BUS_TYPE ":" HW_TYPE ":" FW_TYPE
 #define DBG_MOD_NAME        MODULE_NAME
-- 
1.7.4.1

