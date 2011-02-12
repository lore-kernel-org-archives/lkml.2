Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab1BLCUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:20:30 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56565 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab1BLCU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:20:29 -0500
Date: Fri, 11 Feb 2011 18:20:26 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 17/17] mfd-core: drop data_size from mfd_cell struct
Message-ID: <20110211182026.2ed43463@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

