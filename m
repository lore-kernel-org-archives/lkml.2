Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2EKIUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:20:19 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:53214 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2EKISb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:18:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKjKrE9bdWOb/2dsb2JhbABEtB6BB4IWAQV5EFFXBhOIErsMkTQElX2QQIJr
X-IronPort-AV: E=Sophos;i="4.75,570,1330902000"; 
   d="scan'208";a="513690774"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] Staging: ipack/bridges/tpci200: change the licence to explicitly GPLv2
Date: Fri, 11 May 2012 10:17:14 +0200
Message-Id: <1336724236-21665-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
References: <1336724236-21665-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the licence to explicitly GPLv2 to avoid possible conflicts in the
future.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    3 +--
 drivers/staging/ipack/bridges/tpci200.h |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 08cd851..80cdd9e 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -8,8 +8,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
+ * Software Foundation; version 2 of the License.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index e452da2..75801f6 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -8,8 +8,7 @@
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
+ * Software Foundation; version 2 of the License.
  */
 
 #ifndef _TPCI200_H_
-- 
1.7.10

