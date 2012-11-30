Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab2K3MkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:40:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39016 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2K3MkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:40:04 -0500
Message-ID: <1354279193.8449.2.camel@phoenix>
Subject: [PATCH] regulator: wm831x-dcdc: Add MODULE_ALIAS for wm831x-boostp
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 20:39:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/wm831x-dcdc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index bce2565..731b701 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -993,4 +993,5 @@ MODULE_DESCRIPTION("WM831x DC-DC convertor driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:wm831x-buckv");
 MODULE_ALIAS("platform:wm831x-buckp");
+MODULE_ALIAS("platform:wm831x-boostp");
 MODULE_ALIAS("platform:wm831x-epe");
-- 
1.7.9.5



