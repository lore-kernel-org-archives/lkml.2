Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1IDK1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:27:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39503 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1IDK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:26:25 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 08/12] staging: et131x: Remove duplicated register defines from et1310_phy.h
Date: Sun,  4 Sep 2011 11:24:39 +0100
Message-Id: <1315131883-11068-9-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
References: <1315131883-11068-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VMI_* set of register defines are not used, and duplicate the set of PHY_* registers from the same file, which are used - hence removing.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_phy.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index d996e8e..9cbc185 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -61,24 +61,6 @@
 
 #include "et1310_address_map.h"
 
-/* VMI Register Addresses */
-#define VMI_RESERVED16_REG                  16
-#define VMI_RESERVED17_REG                  17
-#define VMI_RESERVED18_REG                  18
-#define VMI_LOOPBACK_CONTROL_REG            19
-#define VMI_RESERVED20_REG                  20
-#define VMI_MI_CONTROL_REG                  21
-#define VMI_PHY_CONFIGURATION_REG           22
-#define VMI_PHY_CONTROL_REG                 23
-#define VMI_INTERRUPT_MASK_REG              24
-#define VMI_INTERRUPT_STATUS_REG            25
-#define VMI_PHY_STATUS_REG                  26
-#define VMI_LED_CONTROL_1_REG               27
-#define VMI_LED_CONTROL_2_REG               28
-#define VMI_RESERVED29_REG                  29
-#define VMI_RESERVED30_REG                  30
-#define VMI_RESERVED31_REG                  31
-
 /* PHY Register Mapping(MI) Management Interface Regs */
 struct mi_regs {
 	u8 bmcr;	/* Basic mode control reg(Reg 0x00) */
-- 
1.7.6

