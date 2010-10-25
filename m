Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0JYC3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:29:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61190 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0JYC3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:29:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Sm8tme1iGwWT6rI/I2fJEaxsTGgbN872pUy4keMHqA+Ojk3DXnuHQ1msj9MoErQ1zh
         b2ie73AbLLTNqwkucav8P14uWsPqHmtzopfiDCPp75Q7YWViHDfauqzYjeLDtdS5mDYo
         uACjIoaiBIDk1BzNUG5KDTzvwf2sfht5wG3vY=
Subject: [PATCH] mfd: Add __devexit annotation for vx855_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Harald Welte <HaraldWelte@viatech.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 10:32:05 +0800
Message-Id: <1287973925.23608.8.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/vx855.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index ebb0597..348052a 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -112,7 +112,7 @@ out:
 	return ret;
 }
 
-static void vx855_remove(struct pci_dev *pdev)
+static void __devexit vx855_remove(struct pci_dev *pdev)
 {
 	mfd_remove_devices(&pdev->dev);
 	pci_disable_device(pdev);
-- 
1.7.2



