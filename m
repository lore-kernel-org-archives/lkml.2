Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1FMMTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:19:54 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:41845 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab1FMMTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:19:49 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH 4/5] staging/easycap: PAGE_SIZE is always defined
Date: Mon, 13 Jun 2011 16:18:31 +0400
Message-Id: <ae1c276f60740459efdfaf57b577e57841c22683.1307967011.git.kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
In-Reply-To: <cover.1307967011.git.kirr@mns.spb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not 100% sure, only 99.99% that PAGE_SIZE is always defined in
Linux. So there is no need to check for it.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/easycap.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/easycap/easycap.h b/drivers/staging/easycap/easycap.h
index 1f94e23..5d21620 100644
--- a/drivers/staging/easycap/easycap.h
+++ b/drivers/staging/easycap/easycap.h
@@ -85,10 +85,6 @@
 #include <linux/videodev2.h>
 #include <linux/soundcard.h>
 
-#ifndef PAGE_SIZE
-#error "PAGE_SIZE not defined"
-#endif /* PAGE_SIZE */
-
 /*---------------------------------------------------------------------------*/
 /*  VENDOR, PRODUCT:  Syntek Semiconductor Co., Ltd
  *
-- 
1.7.6.rc1

