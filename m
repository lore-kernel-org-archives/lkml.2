Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1C3Rzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:55:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40668 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1C3Rzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tt8ct3zccf7b+UyqNXukGuTTiEkTf4ocKPX+K9YDQrWJHVJjmRtoFJaIuHQuDYZw16
         8X3vX9bAfaAV1hroLmplBsaHzXYMfmtArLSO+aRd9jaFy3f3z4D3ykAmOdzYavpmiOEU
         l1KCNbHbePsRufvpwUhNLqmoh3BePYqalCHH8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V2 3/5]arch:m68k:asm Fix typo occcured.
Date: Wed, 30 Mar 2011 10:55:03 -0700
Message-Id: <1301507703-3364-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below changes a typo occcured to occurred in two comments.
 
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/m68k/include/asm/MC68EZ328.h |    2 +-
 arch/m68k/include/asm/MC68VZ328.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/MC68EZ328.h b/arch/m68k/include/asm/MC68EZ328.h
index 69b7f91..d1bde58 100644
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
index 2b9bf62..6bd1bf1 100644
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
1.7.4.1

