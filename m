Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab2GFP2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:28:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:56992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569Ab2GFP2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119556171"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kevin McKinney <klmckinney1@gmail.com>
Subject: [PATCH 1/6] staging: bcm: use %pM to print MAC addresses
Date: Fri,  6 Jul 2012 18:28:13 +0300
Message-Id: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kevin McKinney <klmckinney1@gmail.com>
---
 drivers/staging/bcm/CmHost.c |   44 +++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 189d243..9c8c9b1 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -967,24 +967,18 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetDestMacAddressLength: 0x%02X ",
 				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddressLength);
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetDestMacAddress[6]: 0x %02X %02X %02X %02X %02X %02X",
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[0],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[1],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[2],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[3],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[4],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[5]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL,
+				DBG_LVL_ALL, "u8EthernetDestMacAddress[6]: %pM",
+				psfCSType->cCPacketClassificationRule.
+						u8EthernetDestMacAddress);
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetSourceMACAddressLength: 0x%02X ",
 				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddressLength);
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetSourceMACAddress[6]: 0x %02X %02X %02X %02X %02X %02X",
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[0],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[1],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[2],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[3],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[4],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[5]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL,
+				DBG_LVL_ALL, "u8EthernetSourceMACAddress[6]: "
+				"%pM", psfCSType->cCPacketClassificationRule.
+						u8EthernetSourceMACAddress);
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthertypeLength: 0x%02X ",
 				psfCSType->cCPacketClassificationRule.u8EthertypeLength);
@@ -1123,24 +1117,18 @@ static VOID DumpCmControlPacket(PVOID pvBuffer)
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetDestMacAddressLength: 0x%02X ",
 				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddressLength);
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetDestMacAddress[6]: 0x %02X %02X %02X %02X %02X %02X",
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[0],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[1],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[2],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[3],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[4],
-				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddress[5]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL,
+				DBG_LVL_ALL, "u8EthernetDestMacAddress[6]: %pM",
+				psfCSType->cCPacketClassificationRule.
+						u8EthernetDestMacAddress);
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetSourceMACAddressLength: 0x%02X ",
 				psfCSType->cCPacketClassificationRule.u8EthernetDestMacAddressLength);
 
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthernetSourceMACAddress[6]: 0x %02X %02X %02X %02X %02X %02X",
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[0],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[1],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[2],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[3],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[4],
-				psfCSType->cCPacketClassificationRule.u8EthernetSourceMACAddress[5]);
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL,
+				DBG_LVL_ALL, "u8EthernetSourceMACAddress[6]: "
+				"%pM", psfCSType->cCPacketClassificationRule.
+						u8EthernetSourceMACAddress);
 
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8EthertypeLength: 0x%02X ", psfCSType->cCPacketClassificationRule.u8EthertypeLength);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, DUMP_CONTROL, DBG_LVL_ALL, "u8Ethertype[3]: 0x%02X %02X %02X",
-- 
1.7.10.4

