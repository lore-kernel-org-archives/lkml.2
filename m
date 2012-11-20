Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab2KTDPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:15:21 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2150 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2KTDPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:15:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 19 Nov 2012 19:15:14 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 1/5] mfd: add battery charger in tps65090 sub devs
Date: Tue, 20 Nov 2012 08:44:45 +0530
Message-ID: <1353381289-11643-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
References: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65090 supports the battery charging and hence adding
the device name in the list of TPS65090 children. Also
remove the tps65090-regulator as it duplicates with
tps65090-pmic for regulator driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 074ae32..9b79d68 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -74,7 +74,7 @@ static struct mfd_cell tps65090s[] = {
 		.name = "tps65090-pmic",
 	},
 	{
-		.name = "tps65090-regulator",
+		.name = "tps65090-charger",
 	},
 };
 
-- 
1.7.1.1

