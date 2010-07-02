Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505Ab0GBMlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 08:41:20 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:32960 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758472Ab0GBMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 08:41:18 -0400
Date: Fri, 2 Jul 2010 16:41:17 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
       Peter Tyser <ptyser@xes-inc.com>, Dave Jiang <djiang@mvista.com>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 2/2] edac: mpc85xx: Add support for MPC8569 EDAC controllers
Message-ID: <20100702124117.GB23320@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply add a proper ID into the device table.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/edac/mpc85xx_edac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 52ca09b..f39b00a 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1120,6 +1120,7 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
 	{ .compatible = "fsl,mpc8555-memory-controller", },
 	{ .compatible = "fsl,mpc8560-memory-controller", },
 	{ .compatible = "fsl,mpc8568-memory-controller", },
+	{ .compatible = "fsl,mpc8569-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{ .compatible = "fsl,mpc8349-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
-- 
1.7.0.5
