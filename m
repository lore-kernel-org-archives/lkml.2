Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1BRDIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:08:24 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51894 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504Ab1BRDIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:14 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/29] mfd-core: drop data_size from mfd_cell struct
Date: Thu, 17 Feb 2011 19:07:24 -0800
Message-Id: <1297998456-7615-18-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there are no more users of this, drop it.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 include/linux/mfd/core.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index aefc378..923ec25 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -36,9 +36,6 @@ struct mfd_cell {
 	/* platform_data can be used to pass data to "generic" drivers */
 	void			*platform_data;
 
-	/* unused */
-	size_t			data_size;
-
 	/*
 	 * These resources can be specified relative to the parent device.
 	 * For accessing hardware you should use resources from the platform dev
-- 
1.7.2.3

