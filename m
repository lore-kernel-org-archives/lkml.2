Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab2ENQVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:21:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4494 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835Ab2ENQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:21:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 09:21:31 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] amba: tegra-ahb: Remove empty *_remove()
Date: Mon, 14 May 2012 19:21:18 +0300
Message-ID: <1337012479-19421-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary empty function.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/amba/tegra-ahb.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
index aa0b1f1..0b6f0b2 100644
--- a/drivers/amba/tegra-ahb.c
+++ b/drivers/amba/tegra-ahb.c
@@ -264,11 +264,6 @@ static int __devinit tegra_ahb_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit tegra_ahb_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static const struct of_device_id tegra_ahb_of_match[] __devinitconst = {
 	{ .compatible = "nvidia,tegra30-ahb", },
 	{ .compatible = "nvidia,tegra20-ahb", },
@@ -277,7 +272,6 @@ static const struct of_device_id tegra_ahb_of_match[] __devinitconst = {
 
 static struct platform_driver tegra_ahb_driver = {
 	.probe = tegra_ahb_probe,
-	.remove = __devexit_p(tegra_ahb_remove),
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.5.4

