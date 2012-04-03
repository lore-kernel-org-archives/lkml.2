Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2DCLf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:35:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37330 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab2DCLfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:35:12 -0400
From: Max Tottenham <mtottenh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Max Tottenham <mtottenh@gmail.com>
Subject: [PATCH 8/8] Staging: bcm: IPv6Protocol.c: coding style fix
Date: Tue,  3 Apr 2012 12:35:31 +0100
Message-Id: <1333452931-3195-8-git-send-email-mtottenh@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
References: <1333452931-3195-1-git-send-email-mtottenh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eighth patch in a series to fix coding style in IPv6Protocol.c
This patch removes some uneeded braces around single line if/for statements

Signed-off-by: Max Tottenham <mtottenh@gmail.com>
---
 drivers/staging/bcm/IPv6Protocol.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/bcm/IPv6Protocol.c b/drivers/staging/bcm/IPv6Protocol.c
index d9c9cef..1da2164 100644
--- a/drivers/staging/bcm/IPv6Protocol.c
+++ b/drivers/staging/bcm/IPv6Protocol.c
@@ -149,9 +149,8 @@ static UCHAR GetIpv6ProtocolPorts(UCHAR *pucPayload, USHORT *pusSrcPort,
 	UCHAR *pucNextHeader = NULL;
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 
-	if (!pucPayload || (usPayloadLength == 0)) {
+	if (!pucPayload || (usPayloadLength == 0))
 		return 0;
-	}
 
 	*pusSrcPort = *pusDestPort = 0;
 	ucHeaderType = ucNextHeader;
@@ -280,9 +279,8 @@ USHORT	IpVersion6(PMINI_ADAPTER Adapter, PVOID pcIpHeader,
 		if (iMatchedSFQueueIndex >= NO_OF_QUEUES) {
 			bClassificationSucceed = FALSE;
 		} else {
-			if (Adapter->PackInfo[iMatchedSFQueueIndex].bActive == FALSE) {
+			if (Adapter->PackInfo[iMatchedSFQueueIndex].bActive == FALSE)
 				bClassificationSucceed = FALSE;
-			}
 		}
 	}
 
@@ -310,9 +308,8 @@ static BOOLEAN MatchSrcIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
 
 
 	/* First Convert the Ip Address in the packet to Host Endian order */
-	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++)
 		aulSrcIP[uiIpv6AddIndex] = ntohl(pstIpv6Header->ulSrcIpAddress[uiIpv6AddIndex]);
-	}
 
 	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPSrcAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
@@ -368,9 +365,8 @@ static BOOLEAN MatchDestIpv6Address(S_CLASSIFIER_RULE *pstClassifierRule,
 
 
 	/* First Convert the Ip Address in the packet to Host Endian order */
-	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++) {
+	for (uiIpv6AddIndex = 0; uiIpv6AddIndex < uiIpv6AddrNoLongWords; uiIpv6AddIndex++)
 		aulDestIP[uiIpv6AddIndex] = ntohl(pstIpv6Header->ulDestIpAddress[uiIpv6AddIndex]);
-	}
 
 	for (uiLoopIndex = 0; uiLoopIndex < uiCountIPDestinationAddresses; uiLoopIndex += uiIpv6AddrNoLongWords) {
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV6_DBG, DBG_LVL_ALL,
-- 
1.7.3.4

