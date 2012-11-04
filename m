Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2KDPa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 10:30:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45917 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2KDPaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 10:30:55 -0500
Message-ID: <1352043042.11324.0.camel@phoenix>
Subject: [PATCH] pinctrl: nomadik: Add terminating entry for
 platform_device_id table
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 04 Nov 2012 23:30:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-nomadik.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index f2fd99b..22f6937 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1922,6 +1922,7 @@ static const struct platform_device_id nmk_pinctrl_id[] = {
 	{ "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
 	{ "pinctrl-db8500", PINCTRL_NMK_DB8500 },
 	{ "pinctrl-db8540", PINCTRL_NMK_DB8540 },
+	{ }
 };
 
 static struct platform_driver nmk_pinctrl_driver = {
-- 
1.7.9.5



