Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1JTLmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 07:42:36 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44853 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1JTLme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 07:42:34 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Christian T. Steigies" <cts@debian.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ingo=20J=C3=BCrgensmann?= <ij@2011.bluespice.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4] zorro: Rename Picasso IV Z2 "MEM" to "RAM" for consistency
Date: Thu, 20 Oct 2011 13:42:22 +0200
Message-Id: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/zorro_ids.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/zorro_ids.h b/include/linux/zorro_ids.h
index 7e74908..74bc53b 100644
--- a/include/linux/zorro_ids.h
+++ b/include/linux/zorro_ids.h
@@ -360,8 +360,8 @@
 #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_RAM	ZORRO_ID(VILLAGE_TRONIC, 0x0B, 0)
 #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_REG	ZORRO_ID(VILLAGE_TRONIC, 0x0C, 0)
 #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_II_II_PLUS_SEGMENTED_MODE	ZORRO_ID(VILLAGE_TRONIC, 0x0D, 0)
-#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_MEM1		ZORRO_ID(VILLAGE_TRONIC, 0x15, 0)
-#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_MEM2		ZORRO_ID(VILLAGE_TRONIC, 0x16, 0)
+#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_RAM1		ZORRO_ID(VILLAGE_TRONIC, 0x15, 0)
+#define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_RAM2		ZORRO_ID(VILLAGE_TRONIC, 0x16, 0)
 #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z2_REG		ZORRO_ID(VILLAGE_TRONIC, 0x17, 0)
 #define  ZORRO_PROD_VILLAGE_TRONIC_PICASSO_IV_Z3		ZORRO_ID(VILLAGE_TRONIC, 0x18, 0)
 #define  ZORRO_PROD_VILLAGE_TRONIC_ARIADNE			ZORRO_ID(VILLAGE_TRONIC, 0xC9, 0)
-- 
1.7.0.4

