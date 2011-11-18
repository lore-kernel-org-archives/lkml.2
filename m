Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1KRF2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 00:28:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65504 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab1KRF2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 00:28:02 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 16/16] Drivers: tty: synclink: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 22:27:54 -0700
Message-Id: <1321594074-9761-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/tty/synclink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 4183441..d24f216 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -4115,7 +4115,7 @@ static int mgsl_claim_resources(struct mgsl_struct *info)
 	} else {
 		/* claim DMA channel */
 		
-		if (request_dma(info->dma_level,info->device_name) < 0){
+		if (request_dma(info->dma_level,info->device_name) < 0) {
 			printk( "%s(%d):Can't request DMA channel on device %s DMA=%d\n",
 				__FILE__,__LINE__,info->device_name, info->dma_level );
 			mgsl_release_resources( info );
-- 
1.7.7.3

