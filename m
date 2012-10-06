Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab2JFUQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:16:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2JFUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:16:02 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 20/49] ACPI/button: convert to module_acpi_driver()
Date: Sat,  6 Oct 2012 16:09:41 -0400
Message-Id: <466e78f779b2b811f77dbd2ebf618ddd42e3ed50.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/button.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 314a3b8..f0d936b 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -450,15 +450,4 @@ static int acpi_button_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static int __init acpi_button_init(void)
-{
-	return acpi_bus_register_driver(&acpi_button_driver);
-}
-
-static void __exit acpi_button_exit(void)
-{
-	acpi_bus_unregister_driver(&acpi_button_driver);
-}
-
-module_init(acpi_button_init);
-module_exit(acpi_button_exit);
+module_acpi_driver(acpi_button_driver);
-- 
1.8.0.rc0.18.gf84667d

