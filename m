Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1GPWhL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 18:37:11 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36838 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1GPWhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 18:37:10 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jul 2011 18:37:10 EDT
Subject: [PATCH] Summary: Follow all suggestions from checkpatch on
 compress.c
From: Toon Schoenmakers <nighteyes1993@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jul 2011 00:30:09 +0200
Message-ID: <1310855409.4191.4.camel@Rarity>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1000a48661b687f6ea762c1a3157d7c2a90d7fd7 Mon Sep 17 00:00:00 2001
From: Toon Schoenmakers <nighteyes1993@gmail.com>
Date: Sun, 17 Jul 2011 00:26:51 +0200
Subject: [PATCH] Summary: Follow all suggestions from checkpatch on compress.c
Signed-off-by: Toon Schoenmakers <nighteyes1993@gmail.com>

---
 drivers/staging/rtl8192u/ieee80211/compress.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/compress.c b/drivers/staging/rtl8192u/ieee80211/compress.c
index 86c23c9..5416ab6 100644
--- a/drivers/staging/rtl8192u/ieee80211/compress.c
+++ b/drivers/staging/rtl8192u/ieee80211/compress.c
@@ -12,10 +12,10 @@
  *
  */
 #include <linux/types.h>
-//#include <linux/crypto.h>
+/*#include <linux/crypto.h>*/
 #include "rtl_crypto.h"
 #include <linux/errno.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/string.h>
 #include "internal.h"
 
-- 
1.7.4.4



