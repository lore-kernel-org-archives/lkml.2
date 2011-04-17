Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1DQSJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:09:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38807 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1DQSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A8LhkoK+t4TOf/y81bSbWs9SYAtnRy1WGc0r4makQU45VTv1DhYrWINizehYX/6qPf
         0krfUBBe5+/DlBF783cqvIl+4QMiR760N/53fOpFxFc/TeBosDPcaT3eNLxw23rc8s4Y
         mC+0P5rjPMtSLlm+eezAMbt09s6QBB0v+A9OA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5 v2]Typo: Remove one to many ccc's in some comments.
Date: Sun, 17 Apr 2011 11:09:07 -0700
Message-Id: <1303063749-8282-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
References: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
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
+#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
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
+#define WATCHDOG_INTF	0x0080	/* Watchdog interrupt occured */
 #define WATCHDOG_CNT_MASK  0x0300	/* Watchdog Counter */
 #define WATCHDOG_CNT_SHIFT 8
 
-- 
1.7.4.4

