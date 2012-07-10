Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2GJCs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:48:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38413 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2GJCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:32 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 2/5] staging: csr: csr_util.h: Remove commented macros
Date: Mon,  9 Jul 2012 23:43:10 -0300
Message-Id: <1341888193-12182-3-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these macros are commented, so we can removed it.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/csr/csr_util.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/csr/csr_util.h b/drivers/staging/csr/csr_util.h
index ce39c7e..5cd6cb4 100644
--- a/drivers/staging/csr/csr_util.h
+++ b/drivers/staging/csr/csr_util.h
@@ -47,17 +47,10 @@ void CsrUInt32ToHex(CsrUint32 number, CsrCharString *str);
 #define CsrMemCmp(s1, s2, n) ((CsrInt32) memcmp((s1), (s2), (n)))
 #define CsrStrCmp(s1, s2) ((CsrInt32) strcmp((s1), (s2)))
 #define CsrStrNCmp(s1, s2, n) ((CsrInt32) strncmp((s1), (s2), (n)))
-/*#define CsrMemChr memchr*/
 #define CsrStrChr strchr
-/*#define CsrStrCSpn strcspn*/
-/*#define CsrStrPBrk strpbrk*/
-/*#define CsrStrRChr strrchr*/
-/*#define CsrStrSpn strspn*/
 #define CsrStrStr strstr
-/*#define CsrStrTok strtok*/
 #define CsrMemSet memset
 #define CsrStrLen strlen
-/*#define CsrVsnprintf(s, n, format, arg) ((CsrInt32) vsnprintf((s), (n), (format), (arg)))*/
 #else /* !CSR_USE_STDC_LIB */
 void *CsrMemCpy(void *dest, const void *src, CsrSize count);
 void *CsrMemMove(void *dest, const void *src, CsrSize count);
-- 
1.7.10.4

