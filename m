Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab2J3MUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:20:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41201 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2J3MT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:19:59 -0400
Date: Tue, 30 Oct 2012 05:19:45 -0700
From: tip-bot for Borislav Petkov <bp@alien8.de>
Message-ID: <tip-43aff26ce1684dae4bf75437b2733371106aa767@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de
In-Reply-To: <1351532410-4887-2-git-send-email-bp@alien8.de>
References: <1351532410-4887-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] EDAC: Change Boris' email address
Git-Commit-ID: 43aff26ce1684dae4bf75437b2733371106aa767
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:19:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43aff26ce1684dae4bf75437b2733371106aa767
Gitweb:     http://git.kernel.org/tip/43aff26ce1684dae4bf75437b2733371106aa767
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 29 Oct 2012 18:40:09 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Oct 2012 10:05:51 +0100

EDAC: Change Boris' email address

My @amd.com address will be invalid soon so move to private
email address.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1351532410-4887-2-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/edac/amd64_edac.h  |    2 +-
 drivers/edac/edac_stub.c   |    2 +-
 drivers/edac/mce_amd_inj.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d48047..8c41396 100644
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
index 6c86f6e..351945f 100644
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
index 66b5151..2ae78f2 100644
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
