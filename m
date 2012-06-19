Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2FSGNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:13:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:62481 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab2FSGNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:13:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159348691"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/4] mei: group wd_interface_reg with watchdog variables within struct mei_device
Date: Tue, 19 Jun 2012 09:13:37 +0300
Message-Id: <1340086417-23090-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
References: <1340086417-23090-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I846c81e5e729461f0a96d3229c0eb9cb1dff9e9a
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 63d7ee9..4fe6533 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -237,6 +237,7 @@ struct mei_device {
 	bool mei_host_buffer_is_empty;
 
 	struct mei_cl wd_cl;
+	bool wd_interface_reg;
 	bool wd_pending;
 	bool wd_stopped;
 	bool wd_bypass;	/* if false, don't refresh watchdog ME client */
@@ -245,7 +246,6 @@ struct mei_device {
 	unsigned char wd_data[MEI_START_WD_DATA_SIZE];
 
 
-
 	struct file *iamthif_file_object;
 	struct mei_cl iamthif_cl;
 	struct mei_cl_cb *iamthif_current_cb;
@@ -259,8 +259,6 @@ struct mei_device {
 	bool iamthif_flow_control_pending;
 	bool iamthif_ioctl;
 	bool iamthif_canceled;
-
-	bool wd_interface_reg;
 };
 
 
-- 
1.7.4.4

