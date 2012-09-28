Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab2I1AeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:34:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51923 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2I1Ad7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:33:59 -0400
Message-ID: <1348792430.11539.2.camel@phoenix>
Subject: [PATCH] extcon: adc-jack: Add missing MODULE_LICENSE
From: Axel Lin <axel.lin@ingics.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        anish kumar <anish.singh@samsung.com>
Date: Fri, 28 Sep 2012 08:33:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be built as a module, add MODULE_LICENSE for it.
For completeness, also adds MODULE_AUTHOR and MODULE_DESCRIPTION.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/extcon/extcon-adc-jack.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 2cc6bec..e87196f 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
@@ -195,3 +196,7 @@ static struct platform_driver adc_jack_driver = {
 };
 
 module_platform_driver(adc_jack_driver);
+
+MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
+MODULE_DESCRIPTION("ADC Jack extcon driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5



