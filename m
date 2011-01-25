Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1AYVeb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:34:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37195 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754003Ab1AYVea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:34:30 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/3WEApXnH3ZGjWVLUop4A+0vCz0QlfFwwDMS8EbG
	WT93V0v3soHOMC
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] video/via: drop deprecated (and unused) i2c_adapter.id
Date: Tue, 25 Jan 2011 22:34:24 +0100
Message-Id: <1295991264-8640-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.2.2
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes an assignment to the deprecated i2c_adapter.id
field. Since the field isn't used anywhere else in the driver it is
save to remove it.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/via/via_i2c.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 3844b55..a172a31 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -209,7 +209,6 @@ static int create_i2c_bus(struct i2c_adapter *adapter,
 	sprintf(adapter->name, "viafb i2c io_port idx 0x%02x",
 		adap_cfg->ioport_index);
 	adapter->owner = THIS_MODULE;
-	adapter->id = 0x01FFFF;
 	adapter->class = I2C_CLASS_DDC;
 	adapter->algo_data = algo;
 	if (pdev)
-- 
1.7.2.2

