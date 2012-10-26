Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab2JZOnJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:43:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57574 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544Ab2JZOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:43:07 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 22:43:06 +0800
Message-ID: <CAPgLHd-wus3WFaR2k_F_2Jixep5tx71A=Y675a99MXwS=bnYKA@mail.gmail.com>
Subject: [PATCH -next] proc_devtree: remove duplicated include from proc_devtree.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: akpm@linux-foundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/proc/proc_devtree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 3d9fd66..de20ec4 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -13,7 +13,6 @@
 #include <linux/of.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/string.h>
 #include <asm/prom.h>
 #include <asm/uaccess.h>
 #include "internal.h"


