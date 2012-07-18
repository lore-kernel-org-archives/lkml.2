Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2GROZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:25:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab2GROZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:25:46 -0400
Message-ID: <5006C763.3030800@gmail.com>
Date: Wed, 18 Jul 2012 22:25:39 +0800
From: Duan Jiong <djduanjiong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vme_user.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e24a6f9..530e7c6 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -31,7 +31,6 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
-#include <linux/mutex.h>
 #include <linux/types.h>
 
 #include <linux/io.h>
-- 
1.7.9.5

