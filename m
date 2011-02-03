Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1BCEVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:21:18 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40106 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690Ab1BCEVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:21:17 -0500
Date: Wed, 2 Feb 2011 20:21:14 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 16/19] mfd-core: drop platform_data/data_size from core
 mfd_cell struct
Message-ID: <20110202202114.0fe56c4d@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
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
 include/linux/mfd/core.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 82b2a5c..c74089e 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -33,10 +33,6 @@ struct mfd_cell {
 	/* driver-specific data for MFD-aware "cell" drivers */
 	void			*driver_data;
 
-	/* These two are unused */
-	void			*platform_data;
-	size_t			data_size;
-
 	/*
 	 * This resources can be specified relatively to the parent device.
 	 * For accessing device you should use resources from device
-- 
1.7.2.3

