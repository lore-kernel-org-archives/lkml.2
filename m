Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2KDPgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:36:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2KDPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:36:32 -0500
Message-ID: <1352043385.11324.4.camel@phoenix>
Subject: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Jamie Iles <jamie@jamieiles.com>, "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 04 Nov 2012 23:36:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/crypto/picoxcell_crypto.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 410a03c..f4d3d8f 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1863,6 +1863,7 @@ static int __devexit spacc_remove(struct platform_device *pdev)
 static const struct platform_device_id spacc_id_table[] = {
 	{ "picochip,spacc-ipsec", },
 	{ "picochip,spacc-l2", },
+	{ }
 };
 
 static struct platform_driver spacc_driver = {
-- 
1.7.9.5



