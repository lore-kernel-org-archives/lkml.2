Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab1BLB71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:59:27 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44816 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1BLB71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:59:27 -0500
Date: Fri, 11 Feb 2011 17:59:23 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 01/17] mfd-core: fix up typos/vagueness in comment
Message-ID: <20110211175923.32a8d17a@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is my interpretation of the comment for mfd_cell's resources.. :)

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 include/linux/mfd/core.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 835996e..1fd7c44 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -39,8 +39,8 @@ struct mfd_cell {
 	size_t			data_size;
 
 	/*
-	 * This resources can be specified relatively to the parent device.
-	 * For accessing device you should use resources from device
+	 * These resources can be specified relative to the parent device.
+	 * For accessing hardware you should use resources from the platform dev
 	 */
 	int			num_resources;
 	const struct resource	*resources;
-- 
1.7.2.3

