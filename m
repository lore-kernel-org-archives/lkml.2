Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2HSDAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:00:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:14941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab2HSC5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422050"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/74] sections: Add __visible to jump_label sections
Date: Sat, 18 Aug 2012 19:56:08 -0700
Message-Id: <1345345030-22211-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/jump_label.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 0976fc4..a39e8e3 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -106,8 +106,8 @@ static __always_inline bool static_key_true(struct static_key *key)
 	return !static_key_false(key);
 }
 
-extern struct jump_entry __start___jump_table[];
-extern struct jump_entry __stop___jump_table[];
+extern __visible struct jump_entry __start___jump_table[];
+extern __visible struct jump_entry __stop___jump_table[];
 
 extern void jump_label_init(void);
 extern void jump_label_lock(void);
-- 
1.7.7.6

