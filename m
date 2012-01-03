Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2ACQuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:50:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2ACQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:50:00 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]Kconfig:acpi Fix typo in comment.
Date: Tue,  3 Jan 2012 08:49:48 -0800
Message-Id: <1325609388-3058-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below fixes a typo I found in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/acpi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index de0e3df..7556913 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -374,7 +374,7 @@ config ACPI_CUSTOM_METHOD
 	depends on DEBUG_FS
 	default n
 	help
-	  This debug facility allows ACPI AML methods to me inserted and/or
+	  This debug facility allows ACPI AML methods to be inserted and/or
 	  replaced without rebooting the system. For details refer to:
 	  Documentation/acpi/method-customizing.txt.
 
-- 
1.7.5.4

