Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab2JOR1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:27:44 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44300 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2JOR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:26:54 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 12/14] staging: csr: Removed a trailing whitespace from io.c
Date: Tue, 16 Oct 2012 02:25:34 +0900
Message-Id: <1350321936-2664-3-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321936-2664-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321936-2664-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, just removing one trailing whitespace, that's all.

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index b7087c7..f910aea 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -781,7 +781,7 @@ uf_find_netdev_priv(netInterface_priv_t *priv)
 		return -1;
 	}
 
-	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES; 
+	for (inst = 0; inst < MAX_UNIFI_DEVS * CSR_WIFI_NUM_INTERFACES;
 		inst++) {
 		if (Unifi_netdev_instances[inst] == priv) {
 			return inst;
-- 
1.7.9.5

