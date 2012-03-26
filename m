Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab2CZF7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:59:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43666 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab2CZF7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:59:41 -0400
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 1/3] i2c-eg20t: Modify MODULE_AUTHOR's email address
Date: Mon, 26 Mar 2012 14:55:23 +0900
Message-Id: <1332741325-7746-1-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/i2c/busses/i2c-eg20t.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-eg20t.c b/drivers/i2c/busses/i2c-eg20t.c
index f086131..d73975b 100644
--- a/drivers/i2c/busses/i2c-eg20t.c
+++ b/drivers/i2c/busses/i2c-eg20t.c
@@ -1063,6 +1063,6 @@ module_exit(pch_pci_exit);
 
 MODULE_DESCRIPTION("Intel EG20T PCH/LAPIS Semico ML7213/ML7223/ML7831 IOH I2C");
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Tomoya MORINAGA. <tomoya-linux@dsn.lapis-semi.com>");
+MODULE_AUTHOR("Tomoya MORINAGA. <tomoya.rohm@gmail.com>");
 module_param(pch_i2c_speed, int, (S_IRUSR | S_IWUSR));
 module_param(pch_clk, int, (S_IRUSR | S_IWUSR));
-- 
1.7.7.6

