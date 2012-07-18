Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2GROi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:38:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65360 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2GROiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:38:25 -0400
Message-ID: <5006CA58.8080301@gmail.com>
Date: Wed, 18 Jul 2012 22:38:16 +0800
From: Duan Jiong <djduanjiong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: mchehab@infradead.org, sakari.ailus@maxwell.research.nokia.com
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smiapp-core.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/media/video/smiapp/smiapp-core.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index 9cf5bda..297acaf 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -33,7 +33,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
-#include <linux/slab.h>
 #include <linux/v4l2-mediabus.h>
 #include <media/v4l2-device.h>
 
-- 
1.7.9.5

