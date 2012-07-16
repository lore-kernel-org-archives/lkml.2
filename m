Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2GPOaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:30:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35524 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2GPOaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:30:16 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: paul.gortmaker@windriver.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging "ste_rmi4" Fix typos 
Date: Mon, 16 Jul 2012 07:30:05 -0700
Message-Id: <1342449005-17407-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "ste_rmi4"

 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
index 11728a0..277491a 100644
--- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
+++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
@@ -655,13 +655,13 @@ static int synpatics_rmi4_touchpad_detect(struct synaptics_rmi4_data *pdata,
 }
 
 /**
- * synpatics_rmi4_touchpad_config() - confiures the rmi4 touchpad device
+ * synaptics_rmi4_touchpad_config() - configures the rmi4 touchpad device
  * @pdata: pointer to synaptics_rmi4_data structure
  * @rfi: pointer to synaptics_rmi4_fn structure
  *
- * This function calls to confiures the rmi4 touchpad device
+ * This function calls to configures the rmi4 touchpad device
  */
-int synpatics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
+int synaptics_rmi4_touchpad_config(struct synaptics_rmi4_data *pdata,
 						struct synaptics_rmi4_fn *rfi)
 {
 	/*
@@ -855,7 +855,7 @@ static int synaptics_rmi4_i2c_query_device(struct synaptics_rmi4_data *pdata)
 			if (rfi->num_of_data_sources) {
 				if (rfi->fn_number ==
 					SYNAPTICS_RMI4_TOUCHPAD_FUNC_NUM) {
-					retval = synpatics_rmi4_touchpad_config
+					retval = synaptics_rmi4_touchpad_config
 								(pdata, rfi);
 					if (retval < 0)
 						return retval;
-- 
1.7.5.4

