Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0LIRXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:23:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:25958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab0LIRXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:23:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="634782559"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 02/11] sep: remove spaces at end of lines
Date: Thu,  9 Dec 2010 09:30:17 -0800
Message-Id: <1291915817-18354-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index a5c0443..241b1b1 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -275,7 +275,7 @@ end_function:
  *	@filp: file handle to SEP device
  *
  *	Open method for the SEP device. Called when userspace opens
- *	the SEP device node. 
+ *	the SEP device node.
  *
  *	Returns zero on success otherwise an error code.
  */
@@ -1811,7 +1811,7 @@ static int sep_prepare_input_dma_table(struct sep_device *sep,
 			info_entry_ptr->bus_address =
 				sep_shared_area_virt_to_bus(sep,
 							in_lli_table_ptr);
-			info_entry_ptr->block_size = 
+			info_entry_ptr->block_size =
 				((num_entries_in_table) << 24) |
 				(table_data_size);
 		}
@@ -2164,7 +2164,7 @@ static int sep_prepare_input_output_dma_table(struct sep_device *sep,
 		error = sep_lock_user_pages(sep, app_virt_in_addr,
 				data_size, &lli_in_array, SEP_DRIVER_IN_FLAG);
 		if (error) {
-			dev_warn(&sep->pdev->dev, 
+			dev_warn(&sep->pdev->dev,
 				"sep_lock_user_pages for input virtual buffer failed\n");
 			goto end_function;
 		}
@@ -2808,7 +2808,7 @@ static int sep_end_transaction_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_prepare_dcb_handler - prepare a control block 
+ *	sep_prepare_dcb_handler - prepare a control block
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
  *
@@ -2873,7 +2873,7 @@ static int sep_free_dcb_handler(struct sep_device *sep)
 }
 
 /**
- *	sep_rar_prepare_output_msg_handler - prepare an output message 
+ *	sep_rar_prepare_output_msg_handler - prepare an output message
  *	@sep: pointer to struct sep_device
  *	@arg: pointer to user parameters
  *
@@ -3557,7 +3557,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	if (error == 0)
 		/* Success */
 		return 0;
-		
+
 end_function_free_irq:
 	free_irq(pdev->irq, sep);
 
@@ -3626,7 +3626,7 @@ static int __init sep_init(void)
 
 
 /**
- *	sep_exit - called to unload driver 
+ *	sep_exit - called to unload driver
  *
  *	Drop the misc devices then remove and unmap the various resources
  *	that are not released by the driver remove method.
-- 
1.6.3.3

