Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0JRKWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 06:22:51 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:34256 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754827Ab0JRKWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 06:22:49 -0400
Date: Mon, 18 Oct 2010 12:19:34 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fusion: fix module parameter descriptions
Message-ID: <20101018121934.3c01bb55@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix module parameter descriptions that line wrap within quotes.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/message/fusion/mptbase.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 6837a8e..2b3519d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -83,18 +83,18 @@ MODULE_VERSION(my_VERSION);
 
 static int mpt_msi_enable_spi;
 module_param(mpt_msi_enable_spi, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI \
-		controllers (default=0)");
+MODULE_PARM_DESC(mpt_msi_enable_spi, " Enable MSI Support for SPI"
+		" controllers (default=0)");
 
 static int mpt_msi_enable_fc;
 module_param(mpt_msi_enable_fc, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC \
-		controllers (default=0)");
+MODULE_PARM_DESC(mpt_msi_enable_fc, " Enable MSI Support for FC"
+		" controllers (default=0)");
 
 static int mpt_msi_enable_sas;
 module_param(mpt_msi_enable_sas, int, 0);
-MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS \
-		controllers (default=0)");
+MODULE_PARM_DESC(mpt_msi_enable_sas, " Enable MSI Support for SAS"
+		" controllers (default=0)");
 
 
 static int mpt_channel_mapping;
@@ -105,8 +105,8 @@ static int mpt_debug_level;
 static int mpt_set_debug_level(const char *val, struct kernel_param *kp);
 module_param_call(mpt_debug_level, mpt_set_debug_level, param_get_int,
 		  &mpt_debug_level, 0600);
-MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h \
-	- (default=0)");
+MODULE_PARM_DESC(mpt_debug_level, " debug level - refer to mptdebug.h"
+	" - (default=0)");
 
 int mpt_fwfault_debug;
 EXPORT_SYMBOL(mpt_fwfault_debug);
-- 
1.7.2.2
