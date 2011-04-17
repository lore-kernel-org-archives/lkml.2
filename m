Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689Ab1DQSve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:51:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1DQSv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j+SlJiRSgRo1eOOpLkSdT37Jxz5JSbtoSuNdmcTM7N4SeaWdJX4cp+r//K9YcOq8mJ
         IMz6OzpBm4gf+fxC7+WSGukZookRGvGHTPSPT+LTC52AXBr6y0CmfEv2QeJs1TH2O8Cm
         xdkGvri0FVScEfvVG1X4RMzIpLe3zjizD3Zz4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5 v3]Typo: Remove one to many ccc's in some comments.
Date: Sun, 17 Apr 2011 11:50:47 -0700
Message-Id: <1303066247-9569-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch is a resend due to rebasing to the current Mainline, fixing
some comments due to having one to many ccc's in the definitions.
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/include/asm/MC68EZ328.h |    2 +-
 arch/m68k/include/asm/MC68VZ328.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/MC68EZ328.h b/arch/m68k/include/asm/MC68EZ328.h
index 69b7f91..b2ee25d 100644
--- a/arch/m68k/include/asm/MC68EZ328.h
+++ b/arch/m68k/include/asm/MC68EZ328.h
@@ -1047,7 +1047,7 @@ typedef volatile struct {
 
 #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
 #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
-#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
+#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occurred */
 #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
 #define WATCHDOG_CNT_SHIFT 8
 
diff --git a/arch/m68k/include/asm/MC68VZ328.h b/arch/m68k/include/asm/MC68VZ328.h
index 2b9bf62..62cd79a 100644
--- a/arch/m68k/include/asm/MC68VZ328.h
+++ b/arch/m68k/include/asm/MC68VZ328.h
@@ -1143,7 +1143,7 @@ typedef struct {
 
 #define WATCHDOG_EN	0x0001	/* Watchdog Enabled */
 #define WATCHDOG_ISEL	0x0002	/* Select the watchdog interrupt */
-#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occcured */
+#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occurred */
 #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
 #define WATCHDOG_CNT_SHIFT 8
 
-- 
1.7.4.4

