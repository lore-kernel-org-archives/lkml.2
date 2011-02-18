Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab1BRDH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:07:57 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51787 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab1BRDHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:53 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/29] mfd-core: fix up typos/vagueness in comment
Date: Thu, 17 Feb 2011 19:07:08 -0800
Message-Id: <1297998456-7615-2-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
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

