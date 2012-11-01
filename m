Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189Ab2KAFrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 01:47:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51739 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2KAFrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 01:47:46 -0400
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 13:47:45 +0800
Message-ID: <CAPgLHd-EaZQ1i72va62Rwohs-prbR1fbEs-L6geiABur1rfwnw@mail.gmail.com>
Subject: [PATCH -next] Staging: silicom: remove unused including <linux/version.h>
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
 drivers/staging/silicom/bp_mod.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/silicom/bp_mod.c b/drivers/staging/silicom/bp_mod.c
index 018b4ff..58c5f5c 100644
--- a/drivers/staging/silicom/bp_mod.c
+++ b/drivers/staging/silicom/bp_mod.c
@@ -9,7 +9,6 @@
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
-#include <linux/version.h>
 
 #include <linux/kernel.h>	/* We're doing kernel work */
 #include <linux/module.h>	/* Specifically, a module */


