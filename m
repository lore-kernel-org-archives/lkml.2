Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab2JZOgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:36:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53777 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2JZOgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:36:46 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 22:36:45 +0800
Message-ID: <CAPgLHd-T9vzG-xyDtRg88BhAOhhBTEOLMybJL5BajgBfoZOgrA@mail.gmail.com>
Subject: [PATCH -next] staging: ced1401: usb1401: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/staging/ced1401/usb1401.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index 88e2cc0..53c9867 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -89,7 +89,6 @@ synchronous non-Urb based transfers.
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>


