Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2EKEjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 00:39:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40182 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab2EKEi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 00:38:59 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: coelho@ti.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] wlcore: wlcore should depend on MAC80211
Date: Fri, 11 May 2012 06:39:54 +0200
Message-Id: <1336711194-26883-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wlcore can't be built if MAC80211 isn't set.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/net/wireless/ti/wlcore/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index 9d04c38..54156b0 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -1,6 +1,6 @@
 config WLCORE
 	tristate "TI wlcore support"
-	depends on WL_TI && GENERIC_HARDIRQS
+	depends on WL_TI && GENERIC_HARDIRQS && MAC80211
 	depends on INET
 	select FW_LOADER
 	---help---
-- 
1.7.8.5

