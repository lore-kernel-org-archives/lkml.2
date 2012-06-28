Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2F1K56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:57:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:32377 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab2F1K5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="161722633"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        dmitry.torokhov@gmail.com, eric.piel@tremplin-utc.net, mjg@redhat.com,
        ike.pan@canonical.com, herton@canonical.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 02/12] ACPI/button: convert to module_acpi_driver()
Date: Thu, 28 Jun 2012 13:59:21 +0300
Message-Id: <1340881171-14811-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/button.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index d27d072..15968ef 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -443,15 +443,4 @@ static int acpi_button_remove(struct acpi_device *device, int type)
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
1.7.10

