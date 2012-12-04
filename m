Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2LDOF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:42613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab2LDOFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975457"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 11/15] mei: drop non existent function prototype
Date: Tue,  4 Dec 2012 16:04:40 +0200
Message-Id: <1354629884-3202-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_amthif_read_message prototype was not dropped
in one of the movinig/renaming patches

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 4d065ad..bc2bedc 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -433,9 +433,6 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 void mei_amthif_run_next_cmd(struct mei_device *dev);
 
 
-int mei_amthif_read_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
-
 int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list);
 
-- 
1.7.4.4

