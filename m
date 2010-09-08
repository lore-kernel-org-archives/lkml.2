Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758066Ab0IHBaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 21:30:06 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36223 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab0IHBaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 21:30:01 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Wu Fengguang <fengguang.wu@intel.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/10] page-types.c: fix name of unpoison interface
Date: Wed,  8 Sep 2010 10:19:41 +0900
Message-Id: <1283908781-13810-11-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1283908781-13810-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs:hwpoison/renew-pfn is the old interface.
This patch renames and fixes it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git v2.6.36-rc2/Documentation/vm/page-types.c v2.6.36-rc2/Documentation/vm/page-types.c
index ccd951f..cc96ee2 100644
--- v2.6.36-rc2/Documentation/vm/page-types.c
+++ v2.6.36-rc2/Documentation/vm/page-types.c
@@ -478,7 +478,7 @@ static void prepare_hwpoison_fd(void)
 	}
 
 	if (opt_unpoison && !hwpoison_forget_fd) {
-		sprintf(buf, "%s/renew-pfn", hwpoison_debug_fs);
+		sprintf(buf, "%s/unpoison-pfn", hwpoison_debug_fs);
 		hwpoison_forget_fd = checked_open(buf, O_WRONLY);
 	}
 }
-- 
1.7.2.2

