Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2KEXWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:22:00 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57131 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab2KEXF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:05:26 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Alasdair Kergon <agk@redhat.com>,
        Neil Brown <neilb@suse.de>
Subject: [PATCH 059/104] drivers/md/persistent-data: remove depends on CONFIG_EXPERIMENTAL
Date: Mon,  5 Nov 2012 15:04:16 -0800
Message-Id: <1352156701-4038-60-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352156701-4038-1-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
while now and is almost always enabled by default. As agreed during the
Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

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

