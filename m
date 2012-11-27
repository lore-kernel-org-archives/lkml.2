Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab2K0Kiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:38:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45716 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2K0Kip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:38:45 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: jaegeuk.kim@samsung.com, chur.lee@samsung.com, sachin.kamat@linaro.org,
        patches@linaro.org
Subject: [PATCH 1/1] f2fs: remove unneeded version.h header file from f2fs.h
Date: Tue, 27 Nov 2012 16:02:16 +0530
Message-Id: <1354012336-32089-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including <linux/version.h> is not necessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 fs/f2fs/f2fs.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7aa70b5..d3f5a70 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 #include <linux/page-flags.h>
 #include <linux/buffer_head.h>
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/crc32.h>
 #include <linux/magic.h>
-- 
1.7.4.1

