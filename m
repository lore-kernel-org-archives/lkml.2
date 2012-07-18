Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2GRNFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:05:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9746 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2GRNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:05:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jul 2012 06:05:45 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] mfd: tps65090: Correcting mfd-cell names
Date: Wed, 18 Jul 2012 18:33:42 +0530
Message-ID: <1342616622-27500-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mfd-cell names are mistyped as TPS65910 instead of TPS65090.
Hence fixing.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 drivers/mfd/tps65090.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 396b9d1..80e24f4 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -71,10 +71,10 @@ static const struct tps65090_irq_data tps65090_irqs[] = {
 
 static struct mfd_cell tps65090s[] = {
 	{
-		.name = "tps65910-pmic",
+		.name = "tps65090-pmic",
 	},
 	{
-		.name = "tps65910-regulator",
+		.name = "tps65090-regulator",
 	},
 };
 
-- 
1.7.1.1

