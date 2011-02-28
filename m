Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1B1Jc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:32:26 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:53989 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab1B1JcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:32:25 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] asm-generic/user.h: Fix spelling in comment
Date: Mon, 28 Feb 2011 10:32:22 +0100
Message-Id: <1298885542-6583-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.28.92419
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, BODY_SIZE_700_799 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two misspellings.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 include/asm-generic/user.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/user.h b/include/asm-generic/user.h
index 8b9c3c9..35638c3 100644
--- a/include/asm-generic/user.h
+++ b/include/asm-generic/user.h
@@ -1,8 +1,8 @@
 #ifndef __ASM_GENERIC_USER_H
 #define __ASM_GENERIC_USER_H
 /*
- * This file may define a 'struct user' structure. However, it it only
- * used for a.out file, which are not supported on new architectures.
+ * This file may define a 'struct user' structure. However, it is only
+ * used for a.out files, which are not supported on new architectures.
  */
 
 #endif	/* __ASM_GENERIC_USER_H */
-- 
1.7.0.4

