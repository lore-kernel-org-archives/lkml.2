Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0LJPbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:31:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:32919 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab0LJPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:31:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,324,1288594800"; 
   d="scan'208";a="582476233"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 1/1] sep: fix comments in sep_get_static_pool_addr_handler
Date: Fri, 10 Dec 2010 07:37:48 -0800
Message-Id: <1291995468-27359-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original comments were inaccurate

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 2681fcf..ac5d569 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2545,10 +2545,8 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 /**
  *	sep_get_static_pool_addr_handler - get static pool address
  *	@sep: pointer to struct sep_device
- *	@arg: parameters from user space application
  *
  *	This function sets the bus and virtual addresses of the static pool
- *	and returns the virtual address
  */
 static int sep_get_static_pool_addr_handler(struct sep_device *sep)
 {
@@ -3036,7 +3034,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			error = -EPERM; /* Not permitted on new chip */
 		break;
 	case SEP_IOCGETSTATICPOOLADDR:
-		/* Get the physical and virtual addresses of the static pool */
+		/* Inform the SEP the bus address of the static pool */
 		error = sep_get_static_pool_addr_handler(sep);
 		break;
 	case SEP_IOCENDTRANSACTION:
-- 
1.6.3.3

