Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1GaX3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 19:29:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33255 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab1GaX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 19:29:37 -0400
Subject: [PATCH -next] power: max8997_charger.c needs module.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Donggeun Kim <dg77.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 07:29:31 +0800
Message-ID: <1312154971.2445.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power/max8997_charger.c uses interfaces from linux/module.h,
so it should include that file.  This fixes build errors.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/max8997_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8997_charger.c b/drivers/power/max8997_charger.c
index 9848fb8..e12b4a2 100644
--- a/drivers/power/max8997_charger.c
+++ b/drivers/power/max8997_charger.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-- 
1.7.4.1



