Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2J2RkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:40:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33366 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab2J2RkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:40:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        EDAC devel <linux-edac@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 2/3] EDAC: Change Boris' email address
Date: Mon, 29 Oct 2012 18:40:09 +0100
Message-Id: <1351532410-4887-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1351532410-4887-1-git-send-email-bp@alien8.de>
References: <1351532410-4887-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My @amd.com address will be invalid soon so move to private email
address.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 drivers/edac/amd64_edac.h  | 2 +-
 drivers/edac/edac_stub.c   | 2 +-
 drivers/edac/mce_amd_inj.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d4804732bac..8c4139647efc 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -33,7 +33,7 @@
  *		detection. The mods to Rev F required more family
  *		information detection.
  *
- *	Changes/Fixes by Borislav Petkov <borislav.petkov@amd.com>:
+ *	Changes/Fixes by Borislav Petkov <bp@alien8.de>:
  *		- misc fixes and code cleanups
  *
  * This module is based on the following documents
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 6c86f6e54558..351945fa2ecd 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -5,7 +5,7 @@
  *
  * 2007 (c) MontaVista Software, Inc.
  * 2010 (c) Advanced Micro Devices Inc.
- *	    Borislav Petkov <borislav.petkov@amd.com>
+ *	    Borislav Petkov <bp@alien8.de>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 66b5151c1080..2ae78f20cc28 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -6,7 +6,7 @@
  * This file may be distributed under the terms of the GNU General Public
  * License version 2.
  *
- * Copyright (c) 2010:  Borislav Petkov <borislav.petkov@amd.com>
+ * Copyright (c) 2010:  Borislav Petkov <bp@alien8.de>
  *			Advanced Micro Devices Inc.
  */
 
@@ -168,6 +168,6 @@ module_init(edac_init_mce_inject);
 module_exit(edac_exit_mce_inject);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Borislav Petkov <borislav.petkov@amd.com>");
+MODULE_AUTHOR("Borislav Petkov <bp@alien8.de>");
 MODULE_AUTHOR("AMD Inc.");
 MODULE_DESCRIPTION("MCE injection facility for testing MCE decoding");
-- 
1.8.0

