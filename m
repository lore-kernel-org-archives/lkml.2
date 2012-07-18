Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2GROan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:30:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38433 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2GROal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:30:41 -0400
Message-ID: <5006C886.80202@gmail.com>
Date: Wed, 18 Jul 2012 22:30:30 +0800
From: Duan Jiong <djduanjiong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, alan@linux.intel.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sep_main.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/staging/sep/sep_main.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index df1d13e..a80c701 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -61,7 +61,6 @@
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <asm/cacheflush.h>
-#include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/async.h>
-- 
1.7.9.5

