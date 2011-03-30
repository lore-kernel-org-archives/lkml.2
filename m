Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab1C3RCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:02:09 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40054 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab1C3RBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DT6ElAIa+yfyWW3rk5nBcudfzFgUAFiAZLK/VSswHP4SYi8OTtqmJhZw5GWauc9sFn
         klYjTA40sya78PokuRAaU6jnTcoyC6AVsACTmUAWvmRYcwYzHxIDM4kLDvfYRW4il6bY
         YngV9Qz85U1Wcz7iYNYhZnNhT7IfOtJSoCoBM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 3/5]arch:m68k:asm Remove one to many ccc's.
Date: Wed, 30 Mar 2011 10:01:16 -0700
Message-Id: <1301504478-3450-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
References: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes one to many ccc's in some comments.

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
1.7.4.1

