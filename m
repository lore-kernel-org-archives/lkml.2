Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2GJCsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:48:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38413 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2GJCri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:47:38 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lauri.hintsala@bluegiga.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 4/5] staging: csr: unifi_sme.c: Remove unused macros
Date: Mon,  9 Jul 2012 23:43:12 -0300
Message-Id: <1341888193-12182-5-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341888193-12182-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are not used, so remove it.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/csr/unifi_sme.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/csr/unifi_sme.c b/drivers/staging/csr/unifi_sme.c
index 6e7cbbf..5ad1d5f 100644
--- a/drivers/staging/csr/unifi_sme.c
+++ b/drivers/staging/csr/unifi_sme.c
@@ -78,12 +78,6 @@ sme_log_event(ul_client_t *pcli,
     CsrResult result = CSR_RESULT_SUCCESS;
     int r;
 
-    /* Following bits are encoded in hostTag These are there to ensure that hostTags are unique*/
-#define CSR_SME_DATA     0x00000000  /* Frames Sent by SME */
-#define CSR_PAL_DATA     0X10000000  /* Frames Sent by PAL-D*/
-#define CSR_NME_DATA     0x20000000  /* Frames Sent by NME*/
-#define APPLICATION_DATA 0x30000000  /* Frames Sent by Application*/
-
     func_enter();
     /* Just a sanity check */
     if ((signal == NULL) || (signal_len <= 0)) {
-- 
1.7.10.4

