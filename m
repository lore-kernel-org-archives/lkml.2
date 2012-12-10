Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab2LJXWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:22:39 -0500
Received: from wren.arvixe.com ([50.97.138.99]:51861 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2LJXWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:36 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 7/9] rtl8712: remove unused definitions from ethernet.h
Date: Mon, 10 Dec 2012 23:21:25 +0000
Message-Id: <1355181685-4444-7-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
References: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/ethernet.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8712/ethernet.h b/drivers/staging/rtl8712/ethernet.h
index 9095420..fad173f 100644
--- a/drivers/staging/rtl8712/ethernet.h
+++ b/drivers/staging/rtl8712/ethernet.h
@@ -26,15 +26,8 @@
 #ifndef __INC_ETHERNET_H
 #define __INC_ETHERNET_H
 
-#define ETHERNET_ADDRESS_LENGTH		6	/*!< Ethernet Address Length*/
 #define ETHERNET_HEADER_SIZE		14	/*!< Ethernet Header Length*/
 #define LLC_HEADER_SIZE			6	/*!< LLC Header Length*/
-#define TYPE_LENGTH_FIELD_SIZE		2	/*!< Type/Length Size*/
-#define MINIMUM_ETHERNET_PACKET_SIZE	60	/*!< Min Ethernet Packet Size*/
-#define MAXIMUM_ETHERNET_PACKET_SIZE	1514	/*!< Max Ethernet Packet Size*/
-
-/*!< Is Multicast Address? */
-#define RT_ETH_IS_MULTICAST(_pAddr)	((((u8 *)(_pAddr))[0]&0x01) != 0)
 
 #endif /* #ifndef __INC_ETHERNET_H */
 
-- 
1.8.0.1

