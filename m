Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab2ENQU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:20:29 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4325 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2ENQU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:20:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 May 2012 09:19:25 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] memory: tegra{20,30}-mc: Remove empty *_remove()
Date: Mon, 14 May 2012 19:20:03 +0300
Message-ID: <1337012410-19067-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary empty functions.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/memory/tegra20-mc.c |    6 ------
 drivers/memory/tegra30-mc.c |    6 ------
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index a38d9d3..3ed49c1 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -241,14 +241,8 @@ static int __devinit tegra20_mc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit tegra20_mc_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static struct platform_driver tegra20_mc_driver = {
 	.probe = tegra20_mc_probe,
-	.remove = __devexit_p(tegra20_mc_remove),
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index cb639b1..e56ff04 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -365,14 +365,8 @@ static int __devinit tegra30_mc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devexit tegra30_mc_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static struct platform_driver tegra30_mc_driver = {
 	.probe = tegra30_mc_probe,
-	.remove = __devexit_p(tegra30_mc_remove),
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
-- 
1.7.5.4

