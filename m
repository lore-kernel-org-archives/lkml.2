Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965384Ab2JYGhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 02:37:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35389 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581Ab2JYGhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 02:37:46 -0400
From: Chihau Chau <chihau@gmail.com>
To: gregkh@linuxfoundation.org, develkernel412222@gmail.com, chihau@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: csr: bh: fixing spaces coding style issues
Date: Thu, 25 Oct 2012 03:37:38 -0300
Message-Id: <1351147058-3197-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues replacing spaces for tab at the end
of some lines

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/csr/bh.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/csr/bh.c b/drivers/staging/csr/bh.c
index addee05..1a1f5c7 100644
--- a/drivers/staging/csr/bh.c
+++ b/drivers/staging/csr/bh.c
@@ -228,20 +228,19 @@ handle_bh_error(unifi_priv_t *priv)
  *
  * ---------------------------------------------------------------------------
  */
-static int
-bh_thread_function(void *arg)
+static int bh_thread_function(void *arg)
 {
-    unifi_priv_t *priv = (unifi_priv_t*)arg;
-    CsrResult csrResult;
-    long ret;
-    u32 timeout, t;
-    struct uf_thread *this_thread;
+	unifi_priv_t *priv = (unifi_priv_t *)arg;
+	CsrResult csrResult;
+	long ret;
+	u32 timeout, t;
+	struct uf_thread *this_thread;
 
-    unifi_trace(priv, UDBG2, "bh_thread_function starting\n");
+	unifi_trace(priv, UDBG2, "bh_thread_function starting\n");
 
-    this_thread = &priv->bh_thread;
+	this_thread = &priv->bh_thread;
 
-    t = timeout = 0;
+	t = timeout = 0;
     while (!kthread_should_stop()) {
         /* wait until an error occurs, or we need to process something. */
         unifi_trace(priv, UDBG3, "bh_thread goes to sleep.\n");
-- 
1.7.1

