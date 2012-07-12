Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161565Ab2GLVGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:06:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53446 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab2GLVGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:06:18 -0400
From: Marek Belisko <marek.belisko@open-nandra.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH] rapidio: tsi721: Fix compilation warning.
Date: Thu, 12 Jul 2012 23:06:08 +0200
Message-Id: <1342127168-23020-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following:
drivers/rapidio/devices/tsi721.c: In function ‘tsi721_probe’:
drivers/rapidio/devices/tsi721.c:2215:6: warning: unused variable ‘i’ [-Wunused-variable]

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/rapidio/devices/tsi721.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 722246c..97e011c 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -2212,7 +2212,7 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
 	struct tsi721_device *priv;
-	int i, cap;
+	int cap;
 	int err;
 	u32 regval;
 
-- 
1.7.9.5

