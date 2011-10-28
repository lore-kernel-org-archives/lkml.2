Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1J1Ahq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 20:37:46 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:40027 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173Ab1J1Ahp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 20:37:45 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Subject: [PATCH 2/2] pch_udc: Change company name OKI SEMICONDUCTOR to LAPIS Semiconductor
Date: Fri, 28 Oct 2011 09:37:35 +0900
Message-Id: <1319762255-7092-2-git-send-email-tomoya-linux@dsn.lapis-semi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1319762255-7092-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1319762255-7092-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On October 1 in 2011,
OKI SEMICONDUCTOR Co., Ltd. changed the company name in to LAPIS Semiconductor Co., Ltd.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
---
 drivers/usb/gadget/pch_udc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 729e974..5048a0c 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 OKI SEMICONDUCTOR CO., LTD.
+ * Copyright (C) 2011 LAPIS Semiconductor Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -3005,5 +3005,5 @@ static void __exit pch_udc_pci_exit(void)
 module_exit(pch_udc_pci_exit);
 
 MODULE_DESCRIPTION("Intel EG20T USB Device Controller");
-MODULE_AUTHOR("OKI SEMICONDUCTOR, <toshiharu-linux@dsn.okisemi.com>");
+MODULE_AUTHOR("LAPIS Semiconductor, <tomoya-linux@dsn.lapis-semi.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.4.4

