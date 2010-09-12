Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab0ILFLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:44 -0400
Received: from mail.perches.com ([173.55.12.10]:1769 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0ILFLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:09 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] drivers/staging/msm: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:57 -0700
Message-Id: <246fad50fa567d22614ec1974ea9b31ea7a685d3.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/msm/staging-devices.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/msm/staging-devices.c b/drivers/staging/msm/staging-devices.c
index 861f330..d6cd919 100644
--- a/drivers/staging/msm/staging-devices.c
+++ b/drivers/staging/msm/staging-devices.c
@@ -166,7 +166,7 @@ static void __init qsd8x50_allocate_memory_regions(void)
 
 	msm_fb_resources[0].start = __pa(addr);
 	msm_fb_resources[0].end = msm_fb_resources[0].start + size - 1;
-	pr_info(KERN_ERR "using %lu bytes of SMI at %lx physical for fb\n",
+	pr_info("using %lu bytes of SMI at %lx physical for fb\n",
 		size, (unsigned long)addr);
 }
 
-- 
1.7.3.rc1

