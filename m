Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466Ab2HSDCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:02:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:1635 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab2HSC5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="204911333"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/74] sections: Add __visible to rapidio sections
Date: Sat, 18 Aug 2012 19:56:07 -0700
Message-Id: <1345345030-22211-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/rapidio/rio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index b1af414..1fd0138 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -44,8 +44,8 @@ extern struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from);
 extern struct device_attribute rio_dev_attrs[];
 extern spinlock_t rio_global_list_lock;
 
-extern struct rio_switch_ops __start_rio_switch_ops[];
-extern struct rio_switch_ops __end_rio_switch_ops[];
+extern __visible struct rio_switch_ops __start_rio_switch_ops[];
+extern __visible struct rio_switch_ops __end_rio_switch_ops[];
 
 /* Helpers internal to the RIO core code */
 #define DECLARE_RIO_SWITCH_SECTION(section, name, vid, did, init_hook) \
-- 
1.7.7.6

