Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1GRWkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 18:40:00 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36190 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1GRWj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 18:39:56 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/3] staging: et131x: Fix variable typo carry_reg1 -> carry_reg2
Date: Mon, 18 Jul 2011 23:38:47 +0100
Message-Id: <1311028727-4758-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311028727-4758-1-git-send-email-mark.einon@gmail.com>
References: <1311028727-4758-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mistake was introduced in the patch 'staging: et131x: Convert et1310_address_map.h names from camel case'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 254f294..8e124fe 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -526,7 +526,7 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
 	carry_reg1 = readl(&etdev->regs->macstat.carry_reg1);
 	carry_reg2 = readl(&etdev->regs->macstat.carry_reg2);
 
-	writel(carry_reg2, &etdev->regs->macstat.carry_reg1);
+	writel(carry_reg1, &etdev->regs->macstat.carry_reg1);
 	writel(carry_reg2, &etdev->regs->macstat.carry_reg2);
 
 	/* We need to do update the host copy of all the MAC_STAT counters.
-- 
1.7.4.4

