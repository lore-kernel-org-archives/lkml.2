Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1KPTjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:39:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53000 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752199Ab1KPTjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:39:06 -0500
From: Joe Perches <joe@perches.com>
To: Rasesh Mody <rmody@brocade.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] bna: Convert MAC_ADDRLEN uses to ETH_ALEN
Date: Wed, 16 Nov 2011 11:38:04 -0800
Message-Id: <8a6f9ad67a3d580565cafb7a44cec0165831c35d.1321472143.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1321472142.git.joe@perches.com>
References: <cover.1321472142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce the number of #defines, use the normal #define from if_ether.h

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/brocade/bna/cna.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/cna.h b/drivers/net/ethernet/brocade/bna/cna.h
index 1b3e90d..32e8f17 100644
--- a/drivers/net/ethernet/brocade/bna/cna.h
+++ b/drivers/net/ethernet/brocade/bna/cna.h
@@ -43,8 +43,7 @@ extern char bfa_version[];
 
 #pragma pack(1)
 
-#define MAC_ADDRLEN	(6)
-typedef struct mac { u8 mac[MAC_ADDRLEN]; } mac_t;
+typedef struct mac { u8 mac[ETH_ALEN]; } mac_t;
 
 #pragma pack()
 
-- 
1.7.6.405.gc1be0

