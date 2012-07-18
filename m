Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2GRBQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 21:16:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2GRBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 21:16:13 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/cptm1217: fix checkpatch warnings
Date: Wed, 18 Jul 2012 10:16:07 +0900
Message-Id: <1342574167-8825-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342427801-8972-1-git-send-email-yamanetoshi@gmail.com>
References: <1342427801-8972-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch error was fixed,

drivers/staging/cptm1217/cp_tm1217.h:5: ERROR: open brace '{' following struct go on the same line

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/cptm1217/cp_tm1217.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/cptm1217/cp_tm1217.h b/drivers/staging/cptm1217/cp_tm1217.h
index a0ce31d..30bad35 100644
--- a/drivers/staging/cptm1217/cp_tm1217.h
+++ b/drivers/staging/cptm1217/cp_tm1217.h
@@ -1,8 +1,7 @@
 #ifndef __LINUX_I2C_CP_TM1217_H
 #define __LINUX_I2C_CP_TM1217_H
 
-struct cp_tm1217_platform_data
-{
+struct cp_tm1217_platform_data {
 	int gpio;		/* If not set uses the IRQ resource 0 */
 };
 
-- 
1.7.5.4

