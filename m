Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2DWMN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:13:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12831 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2DWMNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:13:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Apr 2012 05:13:06 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, jic23@cam.ac.uk, gregkh@linuxfoundation.org,
        swarren@nvidia.com, olof@lixom.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-tegra@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/4] staging: iio: light: of: Fix vendor prefix of isl29018/isl29028
Date: Mon, 23 Apr 2012 17:41:35 +0530
Message-Id: <1335183097-21104-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
References: <1335183097-21104-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISL29018/ISL29028 is from Intersil Corporation and making the
vendor prefix for this part as "isil" for OF compatibity.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Vendor prefix is now "isil"

 drivers/staging/iio/light/isl29018.c |    2 +-
 drivers/staging/iio/light/isl29028.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 073e899..1ec2dac 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -596,7 +596,7 @@ static const struct i2c_device_id isl29018_id[] = {
 MODULE_DEVICE_TABLE(i2c, isl29018_id);
 
 static const struct of_device_id isl29018_of_match[] = {
-	{ .compatible = "invn,isl29018", },
+	{ .compatible = "isil,isl29018", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, isl29018_of_match);
diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
index 4ac49aa..7057d9b 100644
--- a/drivers/staging/iio/light/isl29028.c
+++ b/drivers/staging/iio/light/isl29028.c
@@ -542,7 +542,7 @@ static const struct i2c_device_id isl29028_id[] = {
 MODULE_DEVICE_TABLE(i2c, isl29028_id);
 
 static const struct of_device_id isl29028_of_match[] = {
-	{ .compatible = "isl,isl29028", },
+	{ .compatible = "isil,isl29028", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, isl29028_of_match);
-- 
1.7.1.1

