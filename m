Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2A0FqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:46:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54114 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2A0FqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:46:11 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/3] ethernet: Change author mail address
Date: Fri, 27 Jan 2012 14:45:56 +0900
Message-Id: <1327643159-1302-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
References: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 .../net/ethernet/lapis-semi/pch_gbe/pch_gbe_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/lapis-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/lapis-semi/pch_gbe/pch_gbe_main.c
index a6297fd..c1a99c7 100644
--- a/drivers/net/ethernet/lapis-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/lapis-semi/pch_gbe/pch_gbe_main.c
@@ -2593,7 +2593,7 @@ module_init(pch_gbe_init_module);
 module_exit(pch_gbe_exit_module);
 
 MODULE_DESCRIPTION("EG20T PCH Gigabit ethernet Driver");
-MODULE_AUTHOR("LAPIS SEMICONDUCTOR, <toshiharu-linux@dsn.lapis-semi.com>");
+MODULE_AUTHOR("LAPIS SEMICONDUCTOR, <tomoya.rohm@gmail.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_DEVICE_TABLE(pci, pch_gbe_pcidev_id);
-- 
1.7.7.4

