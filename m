Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2IGHat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:20167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab2IGH33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="189978680"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 02/12] ACPI/button: convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:39 +0300
Message-Id: <1347003109-26887-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/button.c |   13 +------------
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
1.7.10.4

