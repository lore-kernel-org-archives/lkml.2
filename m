Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab0JFUtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:49:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37476 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0JFUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:49:13 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, linux-mm@kvack.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] page-types.c: fix name of unpoison interface
Date: Wed,  6 Oct 2010 22:48:58 +0200
Message-Id: <1286398141-13749-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

The page-types utility still uses an out of date name for the
unpoison interface: debugfs:hwpoison/renew-pfn
This patch renames and fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/vm/page-types.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index ccd951f..cc96ee2 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -478,7 +478,7 @@ static void prepare_hwpoison_fd(void)
 	}
 
 	if (opt_unpoison && !hwpoison_forget_fd) {
-		sprintf(buf, "%s/renew-pfn", hwpoison_debug_fs);
+		sprintf(buf, "%s/unpoison-pfn", hwpoison_debug_fs);
 		hwpoison_forget_fd = checked_open(buf, O_WRONLY);
 	}
 }
-- 
1.7.1

