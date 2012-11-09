Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2KIP2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:28:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2KIP2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:28:16 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: [PATCH 3/3] input:stmpe-ts:Initialize the phys field for input device
Date: Fri,  9 Nov 2012 20:57:50 +0530
Message-Id: <94587f7ddc4cf5503a1824df4c1fb53e553881b7.1352474824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
In-Reply-To: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vipul Kumar Samar <vipulkumar.samar@st.com>

Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
---
 drivers/input/touchscreen/stmpe-ts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index 66b932e..9896095 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -317,6 +317,7 @@ static int __devinit stmpe_input_probe(struct platform_device *pdev)
 		return ret;
 
 	idev->name = STMPE_TS_NAME;
+	idev->phys = STMPE_TS_NAME"/input0";
 	idev->id.bustype = BUS_I2C;
 	idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-- 
1.7.12.rc2.18.g61b472e

