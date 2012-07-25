Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2GYLnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:43:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:65487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab2GYLnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="185825222"
Date: Wed, 25 Jul 2012 19:35:30 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Nicolas Palix <npalix@diku.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Coccinelle: fix typo in memdup_user.cocci
Message-ID: <20120725113530.GA26514@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 scripts/coccinelle/api/memdup_user.cocci |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/coccinelle/api/memdup_user.cocci b/scripts/coccinelle/api/memdup_user.cocci
index 2efac28..2b131a8 100644
--- a/scripts/coccinelle/api/memdup_user.cocci
+++ b/scripts/coccinelle/api/memdup_user.cocci
@@ -51,10 +51,10 @@ statement S1,S2;
 p << r.p;
 @@
 
-coccilib.org.print_todo(p[0], "WARNING opportunity for memdep_user")
+coccilib.org.print_todo(p[0], "WARNING opportunity for memdup_user")
 
 @script:python depends on report@
 p << r.p;
 @@
 
-coccilib.report.print_report(p[0], "WARNING opportunity for memdep_user")
+coccilib.report.print_report(p[0], "WARNING opportunity for memdup_user")
-- 
1.7.10

