Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab1GYVUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:20:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34670 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752695Ab1GYVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:20:41 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] regulator: Add EPEs to the MODULE_ALIAS() for wm831x-dcdc
Date: Mon, 25 Jul 2011 22:20:31 +0100
Message-Id: <1311628834-31939-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311628834-31939-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/wm831x-dcdc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 8a4fdc3..2ee4823 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -1058,3 +1058,4 @@ MODULE_DESCRIPTION("WM831x DC-DC convertor driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:wm831x-buckv");
 MODULE_ALIAS("platform:wm831x-buckp");
+MODULE_ALIAS("platform:wm831x-epe");
-- 
1.7.5.4

