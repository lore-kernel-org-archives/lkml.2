Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2LYRIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 12:08:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:16881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab2LYRGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 12:06:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,353,1355126400"; 
   d="scan'208";a="184664458"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [RESEND char-misc-next 10/14] mei: drop nonexistent function prototype
Date: Tue, 25 Dec 2012 19:06:08 +0200
Message-Id: <1356455172-31959-11-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
References: <1356455172-31959-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_amthif_read_message prototype was not dropped
in one of the moving/renaming patches

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index b437f8b..107a820 100644
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

