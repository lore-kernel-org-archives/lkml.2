Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3AHVKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:10:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3AHVIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605101"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 15/21] mei: remove mei_csr_clear_his prototype
Date: Tue,  8 Jan 2013 23:07:26 +0200
Message-Id: <1357679252-12958-16-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function mei_csr_clear_his is not implemented

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/mei_dev.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index e42db31..88fa194 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -386,11 +386,10 @@ void mei_watchdog_unregister(struct mei_device *dev);
  */
 
 u32 mei_hcsr_read(const struct mei_device *dev);
+void mei_hcsr_set(struct mei_device *dev);
 u32 mei_mecsr_read(const struct mei_device *dev);
 u32 mei_mecbrw_read(const struct mei_device *dev);
 
-void mei_hcsr_set(struct mei_device *dev);
-void mei_csr_clear_his(struct mei_device *dev);
 
 void mei_clear_interrupts(struct mei_device *dev);
 void mei_enable_interrupts(struct mei_device *dev);
-- 
1.7.4.4

