Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab1J1Uxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 16:53:37 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:50800 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326Ab1J1Uxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 16:53:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] i825xx: Fix incorrect dependency for BVME6000_NET
Date: Fri, 28 Oct 2011 22:53:32 +0200
Message-Id: <1319835212-19473-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/i825xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/Kconfig b/drivers/net/ethernet/i825xx/Kconfig
index 2be4698..ca1ae98 100644
--- a/drivers/net/ethernet/i825xx/Kconfig
+++ b/drivers/net/ethernet/i825xx/Kconfig
@@ -85,7 +85,7 @@ config APRICOT
 
 config BVME6000_NET
 	tristate "BVME6000 Ethernet support"
-	depends on BVME6000MVME16x
+	depends on BVME6000
 	---help---
 	  This is the driver for the Ethernet interface on BVME4000 and
 	  BVME6000 VME boards.  Say Y here to include the driver for this chip
-- 
1.7.0.4

