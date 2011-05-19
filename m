Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1ESXBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:01:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8747 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab1ESXBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:01:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 19 May 2011 16:01:36 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: cbouatmailru@gmail.com
Cc: bleung@google.com, olof@lixom.net, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/2] power: bq20z75: enable detection after registering
Date: Thu, 19 May 2011 16:00:04 -0700
Message-Id: <1305846004-11895-2-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
References: <1305846004-11895-1-git-send-email-rklein@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need to enable detection, which is also blocking the unit conversion logic
after registering the power_supply.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 drivers/power/bq20z75.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
index 9c5e5be..e1adc0e 100644
--- a/drivers/power/bq20z75.c
+++ b/drivers/power/bq20z75.c
@@ -702,8 +702,6 @@ skip_gpio:
 
 	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
 
-	bq20z75_device->enable_detection = true;
-
 	return 0;
 
 exit_psupply:
-- 
1.7.5.1

