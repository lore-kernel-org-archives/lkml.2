Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab2BUC7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 21:59:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49865 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab2BUC7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 21:59:54 -0500
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] MM: fix a typo of truncate_inode_pages_range
Date: Tue, 21 Feb 2012 10:57:20 +0800
Message-Id: <1329793040-21406-1-git-send-email-liubo2009@cn.fujitsu.com>
X-Mailer: git-send-email 1.6.5.2
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 10:58:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 10:58:10,
	Serialize complete at 2012-02-21 10:58:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The typo of API truncate_inode_pages_range is not updated.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 mm/truncate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 632b15e..a188058 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -184,7 +184,7 @@ int invalidate_inode_page(struct page *page)
 }
 
 /**
- * truncate_inode_pages - truncate range of pages specified by start & end byte offsets
+ * truncate_inode_pages_range - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate
-- 
1.6.5.2

