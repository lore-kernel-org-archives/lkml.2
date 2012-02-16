Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2BPF6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:58:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45301 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2BPF6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:58:30 -0500
Message-ID: <1329371899.2707.2.camel@phoenix>
Subject: [PATCH] mfd: Show correct device id for wm8400
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 16 Feb 2012 13:58:19 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8400-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 2204893..e60d524 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -271,8 +271,7 @@ static int wm8400_init(struct wm8400 *wm8400,
 		return -EIO;
 	}
 	if (i != reg_data[WM8400_RESET_ID].default_val) {
-		dev_err(wm8400->dev, "Device is not a WM8400, ID is %x\n",
-			reg);
+		dev_err(wm8400->dev, "Device is not a WM8400, ID is %x\n", i);
 		return -ENODEV;
 	}
 
-- 
1.7.5.4



