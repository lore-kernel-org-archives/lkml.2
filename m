Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1J1AX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:23:59 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6779 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab1J1AX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:23:56 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] pch_gpio: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:23:33 +0900
Message-Id: <1319761413-6438-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319761413-6438-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319761413-6438-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/gpio/gpio-pch.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index 8d9116f..3dd9a01 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -49,8 +49,8 @@ struct pch_regs {
 
 enum pch_type_t {
 	INTEL_EG20T_PCH,
-	OKISEMI_ML7223m_IOH, /* OKISEMI ML7223 IOH PCIe Bus-m */
-	OKISEMI_ML7223n_IOH  /* OKISEMI ML7223 IOH PCIe Bus-n */
+	OKISEMI_ML7223m_IOH, /* LAPIS Semiconductor ML7223 IOH PCIe Bus-m */
+	OKISEMI_ML7223n_IOH  /* LAPIS Semiconductor ML7223 IOH PCIe Bus-n */
 };
 
 /* Specifies number of GPIO PINS */
-- 
1.7.4.4

