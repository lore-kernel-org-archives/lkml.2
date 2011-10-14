Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab1JNMcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:32:20 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:39654 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab1JNMcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:32:18 -0400
Subject: [PATCH 19/21] scsi: drop unused Kconfig symbol
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:30:47 +0200
Message-ID: <1318595447.6132.78.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/scsi/Kconfig |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3878b73..8a1a23f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -607,20 +607,6 @@ config SCSI_ARCMSR
 	  To compile this driver as a module, choose M here: the
 	  module will be called arcmsr (modprobe arcmsr).
 
-config SCSI_ARCMSR_AER
-	bool "Enable PCI Error Recovery Capability in Areca Driver(ARCMSR)"
-	depends on SCSI_ARCMSR && PCIEAER
-	default n
-	help
-	  The advanced error reporting(AER) capability is "NOT" provided by
-	  ARC1200/1201/1202 SATA RAID controllers cards.
-	  If your card is one of ARC1200/1201/1202, please use the default setting, n.
-	  If your card is other models, you could pick it
-	  on condition that the kernel version is greater than 2.6.19.
-	  This function is maintained driver by Nick Cheng. If you have any
-	  problems or suggestion, you are welcome to contact with <nick.cheng@areca.com.tw>.
-	  To enable this function, choose Y here.
-
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt2sas/Kconfig"
 
-- 
1.7.4.4




