Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab1IYSTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 14:19:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1IYSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 14:19:30 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@linux.intel.com,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 5/6] staging: et131x: Remove header declaration of et131x_check_mii()
Date: Sun, 25 Sep 2011 19:17:56 +0100
Message-Id: <1316974677-17108-5-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
References: <1316974677-17108-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

et131x_check_mii no longer exists, remove its declaration from the header file

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 6f8fef6..c047e6e 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -107,8 +107,6 @@ int32_t et131x_mii_read(struct et131x_adapter *adapter,
 		u8 reg, u16 *value);
 int32_t et131x_mii_write(struct et131x_adapter *adapter,
 		u8 reg, u16 value);
-void et131x_mii_check(struct et131x_adapter *adapter,
-		      u16 bmsr, u16 bmsr_ints);
 
 int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg);
 int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value);
-- 
1.7.6

