Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab2JORZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:25:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34948 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab2JORZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:25:04 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 09/14] staging: csr: Fixed foo * bar --> foo *bar on io.c
Date: Tue, 16 Oct 2012 02:24:28 +0900
Message-Id: <1350321868-2613-9-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321868-2613-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321868-2613-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were just a few minor errors like foo * bar, so I fixed them.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index 934eacd..e85fe94 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -85,7 +85,7 @@ static int uf_read_proc(char *page, char **start, off_t offset, int count,
 
 #ifdef CSR_WIFI_RX_PATH_SPLIT
 
-static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
+static CsrResult signal_buffer_init(unifi_priv_t *priv, int size)
 {
 	int i;
 	func_enter();
@@ -115,7 +115,7 @@ static CsrResult signal_buffer_init(unifi_priv_t * priv, int size)
 }
 
 
-static void signal_buffer_free(unifi_priv_t * priv, int size)
+static void signal_buffer_free(unifi_priv_t *priv, int size)
 {
 	int i;
 
-- 
1.7.9.5

