Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2FQPPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 11:15:13 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39537 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab2FQPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 11:15:11 -0400
From: Otavio Salvador <otavio@ossystems.com.br>
To: linux-kernel@vger.kernel.org
Cc: Otavio Salvador <otavio@ossystems.com.br>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 1/2] w1: Fix a typo in 'hardware' word
Date: Sun, 17 Jun 2012 12:17:31 -0300
Message-Id: <1339946252-21019-1-git-send-email-otavio@ossystems.com.br>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 6828835..afa5f5d 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -117,7 +117,7 @@ int w1_add_master_device(struct w1_bus_master *master)
 		return(-EINVAL);
         }
 	/* While it would be electrically possible to make a device that
-	 * generated a strong pullup in bit bang mode, only hardare that
+	 * generated a strong pullup in bit bang mode, only hardware that
 	 * controls 1-wire time frames are even expected to support a strong
 	 * pullup.  w1_io.c would need to support calling set_pullup before
 	 * the last write_bit operation of a w1_write_8 which it currently
-- 
1.7.10

