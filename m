Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1BNXDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:03:08 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12271 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab1BNXDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:03:07 -0500
Date: Tue, 15 Feb 2011 00:02:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: "Nicholas A. Bellinger" <nab@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>, trivial@kernel.org
Subject: [PATCH][trivial] iSCSI HBA Transport, target: Fix duplicate include
 and typo in drivers/target/target_core_hba.c
Message-ID: <alpine.LNX.2.00.1102142355020.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

target/target_core_device.h is included twice in 
drivers/target/target_core_hba.c .  This patch removes the duplicate.
Also correct a typo: copntains --> contains .

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 4bbe820..8780ba8 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -1,7 +1,7 @@
 /*******************************************************************************
  * Filename:  target_core_hba.c
  *
- * This file copntains the iSCSI HBA Transport related functions.
+ * This file contains the iSCSI HBA Transport related functions.
  *
  * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
  * Copyright (c) 2005, 2006, 2007 SBE, Inc.
@@ -38,7 +38,6 @@
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
-#include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_transport.h>
 
 

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

