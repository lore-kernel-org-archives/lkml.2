Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2DYIR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:17:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35171 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2DYIRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:17:55 -0400
Message-ID: <1335341866.7324.3.camel@phoenix>
Subject: [PATCH] mfd: ucb1x00-core: Remove obsolete modalias with "mcp:"
 prefix
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jochen Friedrich <jochen@scram.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Wed, 25 Apr 2012 16:17:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for modalis with "mcp:" prefix is removed by commit 65f2e7
Revert "ARM: sa11x0: Implement autoloading of codec and codec pdata for mcp bus."

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/ucb1x00-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 70f02da..72b2447 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -782,7 +782,6 @@ EXPORT_SYMBOL(ucb1x00_adc_disable);
 EXPORT_SYMBOL(ucb1x00_register_driver);
 EXPORT_SYMBOL(ucb1x00_unregister_driver);
 
-MODULE_ALIAS("mcp:ucb1x00");
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_DESCRIPTION("UCB1x00 core driver");
 MODULE_LICENSE("GPL");
-- 
1.7.5.4



