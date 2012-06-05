Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2FEPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:14:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52568 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab2FEPOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:14:43 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] Extcon: Staticise extcon_class
Date: Tue,  5 Jun 2012 16:14:38 +0100
Message-Id: <1338909278-31247-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's not referenced outside the core file.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon_class.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon_class.c b/drivers/extcon/extcon_class.c
index f598a70..99f7227 100644
--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -65,7 +65,7 @@ const char *extcon_cable_name[] = {
 	NULL,
 };
 
-struct class *extcon_class;
+static struct class *extcon_class;
 #if defined(CONFIG_ANDROID)
 static struct class_compat *switch_class;
 #endif /* CONFIG_ANDROID */
-- 
1.7.10

