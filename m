Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3AHVIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:30120 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab3AHVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605011"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 09/21] mei: mei_dev.h - remove prototypes of dropped functions
Date: Tue,  8 Jan 2013 23:07:20 +0200
Message-Id: <1357679252-12958-10-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_task_initialize_clients and mei_initialize_clients
are no longer among us

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index d07d81f..681c0ee 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -326,10 +326,6 @@ static inline unsigned long mei_secs_to_jiffies(unsigned long sec)
 struct mei_device *mei_device_init(struct pci_dev *pdev);
 void mei_reset(struct mei_device *dev, int interrupts);
 int mei_hw_init(struct mei_device *dev);
-int mei_task_initialize_clients(void *data);
-int mei_initialize_clients(struct mei_device *dev);
-
-
 
 /*
  *  MEI interrupt functions prototype
-- 
1.7.4.4

