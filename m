Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2A0FqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 00:46:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42703 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2A0FqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 00:46:01 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 2/3] ethernet/pch_gbe: add Intel EG20T PCH
Date: Fri, 27 Jan 2012 14:45:55 +0900
Message-Id: <1327643159-1302-2-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
References: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch deleted description "Intel EG20T PCH".
So, I add this again.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
 drivers/net/ethernet/lapis-semi/pch_gbe/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/lapis-semi/pch_gbe/Kconfig b/drivers/net/ethernet/lapis-semi/pch_gbe/Kconfig
index 7dd8dc7..af3768c 100644
--- a/drivers/net/ethernet/lapis-semi/pch_gbe/Kconfig
+++ b/drivers/net/ethernet/lapis-semi/pch_gbe/Kconfig
@@ -3,7 +3,7 @@
 #
 
 config PCH_GBE
-	tristate "LAPIS SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
+	tristate "Intel EG20T PCH/LAPIS Semicon IOH(ML7223/ML7831) GbE"
 	depends on PCI
 	select NET_CORE
 	select MII
-- 
1.7.7.4

