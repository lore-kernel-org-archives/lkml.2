Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab2IGHah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:25707 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972Ab2IGH3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="198506218"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 12/12] xo15-ebook: convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:49 +0300
Message-Id: <1347003109-26887-13-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/platform/x86/xo15-ebook.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/platform/x86/xo15-ebook.c b/drivers/platform/x86/xo15-ebook.c
index 38ba39d..16d340c 100644
--- a/drivers/platform/x86/xo15-ebook.c
+++ b/drivers/platform/x86/xo15-ebook.c
@@ -170,16 +170,4 @@ static struct acpi_driver xo15_ebook_driver = {
 	},
 	.drv.pm = &ebook_switch_pm,
 };
-
-static int __init xo15_ebook_init(void)
-{
-	return acpi_bus_register_driver(&xo15_ebook_driver);
-}
-
-static void __exit xo15_ebook_exit(void)
-{
-	acpi_bus_unregister_driver(&xo15_ebook_driver);
-}
-
-module_init(xo15_ebook_init);
-module_exit(xo15_ebook_exit);
+module_acpi_driver(xo15_ebook_driver);
-- 
1.7.10.4

