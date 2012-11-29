Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2K2CWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:22:45 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37521 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab2K2CWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:22:44 -0500
MIME-Version: 1.0
Date: Wed, 28 Nov 2012 21:22:43 -0500
Message-ID: <CAPgLHd-9_p_haRkx-2D_5eT-E6_g84N=Hjs4JB5gu_kPVSp2Vw@mail.gmail.com>
Subject: [PATCH -next] hv: hv_balloon: remove duplicated include from hv_balloon.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: yongjun_wei@trendmicro.com.cn, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hv/hv_balloon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index f6c0011..0ce08c4 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -29,7 +29,6 @@
 #include <linux/memory_hotplug.h>
 #include <linux/memory.h>
 #include <linux/notifier.h>
-#include <linux/mman.h>
 #include <linux/percpu_counter.h>
 
 #include <linux/hyperv.h>

