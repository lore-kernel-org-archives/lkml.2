Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0INEYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:24:53 -0400
Received: from mail.perches.com ([173.55.12.10]:1988 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0INEYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:13 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH next 05/16] drivers/gpu: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:23:51 -0700
Message-Id: <d2e0b63c75ea1cfe92bb309408e0bb29e7580959.1284435709.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
index ca90479..578ea3b 100644
--- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
+++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
@@ -836,7 +836,9 @@ int ttm_page_alloc_debugfs(struct seq_file *m, void *data)
 {
 	struct ttm_page_pool *p;
 	unsigned i;
-	char *h[] = {"pool", "refills", "pages freed", "size"};
+	static const char * const h[] = {
+		"pool", "refills", "pages freed", "size"
+	};
 	if (!_manager) {
 		seq_printf(m, "No pool allocator running.\n");
 		return 0;
-- 
1.7.3.rc1

