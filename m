Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab2JWGRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60559 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2JWGRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:32 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: mturquette@linaro.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 3/4] MIPS: Loongson1B: Update stmmac_mdio_bus_data
Date: Tue, 23 Oct 2012 14:17:02 +0800
Message-Id: <1350973023-7667-4-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
References: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update stmmac_mdio_bus_data accordingly due to the upstream change.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/loongson1/common/platform.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/loongson1/common/platform.c b/arch/mips/loongson1/common/platform.c
index 5ca38dc..3a42276 100644
--- a/arch/mips/loongson1/common/platform.c
+++ b/arch/mips/loongson1/common/platform.c
@@ -71,7 +71,6 @@ static struct resource ls1x_eth0_resources[] = {
 };
 
 static struct stmmac_mdio_bus_data ls1x_mdio_bus_data = {
-	.bus_id		= 0,
 	.phy_mask	= 0,
 };
 
-- 
1.7.1

