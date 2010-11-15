Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab0KODMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:12:54 -0500
Received: from mail.perches.com ([173.55.12.10]:1156 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660Ab0KODFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:35 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/44] drivers/net/bnx2x: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:31 -0800
Message-Id: <2bfaf1f1fe5d503a8a386a433b5187997819d771.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/bnx2x/bnx2x_link.c |    4 ++--
 drivers/net/bnx2x/bnx2x_main.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_link.c b/drivers/net/bnx2x/bnx2x_link.c
index 5809196..38aeffe 100644
--- a/drivers/net/bnx2x/bnx2x_link.c
+++ b/drivers/net/bnx2x/bnx2x_link.c
@@ -3904,7 +3904,7 @@ static u8 bnx2x_8726_read_sfp_module_eeprom(struct bnx2x_phy *phy,
 			      MDIO_PMA_REG_SFP_TWO_WIRE_CTRL, &val);
 		if ((val & MDIO_PMA_REG_SFP_TWO_WIRE_CTRL_STATUS_MASK) ==
 		    MDIO_PMA_REG_SFP_TWO_WIRE_STATUS_IDLE)
-			return 0;;
+			return 0;
 		msleep(1);
 	}
 	return -EINVAL;
@@ -3988,7 +3988,7 @@ static u8 bnx2x_8727_read_sfp_module_eeprom(struct bnx2x_phy *phy,
 			      MDIO_PMA_REG_SFP_TWO_WIRE_CTRL, &val);
 		if ((val & MDIO_PMA_REG_SFP_TWO_WIRE_CTRL_STATUS_MASK) ==
 		    MDIO_PMA_REG_SFP_TWO_WIRE_STATUS_IDLE)
-			return 0;;
+			return 0;
 		msleep(1);
 	}
 
diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index e9ad16f..7ffcb08 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -8078,7 +8078,7 @@ static void __devinit bnx2x_get_port_hwinfo(struct bnx2x *bp)
 	int port = BP_PORT(bp);
 	u32 val, val2;
 	u32 config;
-	u32 ext_phy_type, ext_phy_config;;
+	u32 ext_phy_type, ext_phy_config;
 
 	bp->link_params.bp = bp;
 	bp->link_params.port = port;
-- 
1.7.3.1.g432b3.dirty

