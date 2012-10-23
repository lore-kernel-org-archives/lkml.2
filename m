Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab2JWU3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:29:01 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39959 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964864Ab2JWUGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:03 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Alasdair Kergon <agk@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH 062/193] drivers/md/persistent-data: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:02:15 -0700
Message-Id: <1351022666-6960-63-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: Alasdair Kergon <agk@redhat.com>
CC: Neil Brown <neilb@suse.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/md/persistent-data/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/Kconfig b/drivers/md/persistent-data/Kconfig
index ceb3590..19b2687 100644
--- a/drivers/md/persistent-data/Kconfig
+++ b/drivers/md/persistent-data/Kconfig
@@ -1,6 +1,6 @@
 config DM_PERSISTENT_DATA
        tristate
-       depends on BLK_DEV_DM && EXPERIMENTAL
+       depends on BLK_DEV_DM
        select LIBCRC32C
        select DM_BUFIO
        ---help---
-- 
1.7.9.5

