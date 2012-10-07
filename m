Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2JGPzz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 11:55:55 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8870 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab2JGPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 11:55:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 07 Oct 2012 08:53:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <vbyravarasu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] mfd: add battery charger in tps65090 sub devs
Date: Sun, 7 Oct 2012 20:52:16 +0530
Message-ID: <1349623340-21807-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com>
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

