Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab2K3Ea4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:30:56 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55951 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2K3Eay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:30:54 -0500
Message-ID: <1354249845.18712.2.camel@phoenix>
Subject: [PATCH] OMAPDSS: Add terminating entry for picodlp_i2c_id table
From: Axel Lin <axel.lin@ingics.com>
To: Archit Taneja <archit@ti.com>
Cc: Mythri P K <mythripk@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 12:30:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/omap2/displays/panel-picodlp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/omap2/displays/panel-picodlp.c b/drivers/video/omap2/displays/panel-picodlp.c
index e3a6c19..1b94018 100644
--- a/drivers/video/omap2/displays/panel-picodlp.c
+++ b/drivers/video/omap2/displays/panel-picodlp.c
@@ -50,6 +50,7 @@ struct picodlp_i2c_data {
 
 static struct i2c_device_id picodlp_i2c_id[] = {
 	{ "picodlp_i2c_driver", 0 },
+	{ }
 };
 
 struct picodlp_i2c_command {
-- 
1.7.9.5



