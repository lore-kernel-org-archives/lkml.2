Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab1A1EFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:05:10 -0500
Received: from mail.perches.com ([173.55.12.10]:3448 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab1A1EEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:04:54 -0500
From: Joe Perches <joe@perches.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] staging: ath6kl: Convert 0 to FALSE
Date: Thu, 27 Jan 2011 20:04:27 -0800
Message-Id: <3e41c8eb63430d567c0bfb76a7c6280e96e580ad.1296186677.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1296186677.git.joe@perches.com>
References: <cover.1296186677.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a set of an A_BOOL from 0 to FALSE.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_android.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_android.c b/drivers/staging/ath6kl/os/linux/ar6000_android.c
index 88487cc..ce1a94c 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_android.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_android.c
@@ -29,7 +29,7 @@
 #include <linux/earlysuspend.h>
 #endif
 
-A_BOOL enable_mmc_host_detect_change = 0;
+A_BOOL enable_mmc_host_detect_change = FALSE;
 static void ar6000_enable_mmchost_detect_change(int enable);
 
 
-- 
1.7.4.rc3

