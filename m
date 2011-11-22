Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1KVK4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 05:56:14 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:64058 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab1KVK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 05:56:11 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/3] dmaengine: at_hdmac: add const to struct platform_device_id definition
Date: Tue, 22 Nov 2011 11:55:52 +0100
Message-Id: <25000153a64c2845223be78ee55e01e034613601.1321959137.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 3b0c28f..3b44f24 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1191,7 +1191,7 @@ static const struct of_device_id atmel_dma_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, atmel_dma_dt_ids);
 #endif
 
-static struct platform_device_id atdma_devtypes[] = {
+static const struct platform_device_id atdma_devtypes[] = {
 	{
 		.name = "at91sam9rl_dma",
 		.driver_data = ATDMA_DEVTYPE_SAM9RL,
-- 
1.7.5.4

