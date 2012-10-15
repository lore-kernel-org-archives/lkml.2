Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2JOR04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:26:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2JOR0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:26:52 -0400
From: Sangho Yi <antiroot@gmail.com>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Sangho Yi <antiroot@gmail.com>
Subject: [PATCH 11/14] staging: csr: Fixed minor coding style error like array = {{..}};
Date: Tue, 16 Oct 2012 02:25:33 +0900
Message-Id: <1350321936-2664-2-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350321936-2664-1-git-send-email-antiroot@gmail.com>
References: <n>
 <1350321936-2664-1-git-send-email-antiroot@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style error like array = {{...., ...}}; to ...} };

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/staging/csr/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/csr/io.c b/drivers/staging/csr/io.c
index ae069f0..b7087c7 100644
--- a/drivers/staging/csr/io.c
+++ b/drivers/staging/csr/io.c
@@ -516,7 +516,7 @@ cleanup_unifi_sdio(unifi_priv_t *priv)
 	int priv_instance;
 	int i;
 	static const CsrWifiMacAddress broadcast_address = {{0xFF,
-		0xFF, 0xFF, 0xFF, 0xFF, 0xFF}};
+		0xFF, 0xFF, 0xFF, 0xFF, 0xFF} };
 
 	func_enter();
 
-- 
1.7.9.5

