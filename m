Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2JGNXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:23:55 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:33657 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2JGNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:23:48 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:23:47 +0800
Message-ID: <CAPgLHd95Tv12n=yaSoM-nKtOd0NGiRq-LYe1H_NcFwQUS8U0YQ@mail.gmail.com>
Subject: [PATCH] dgrp: remove unused including <linux/version.h>
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
 drivers/staging/dgrp/dgrp_sysfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
index e5a3c88..a13318c 100644
--- a/drivers/staging/dgrp/dgrp_sysfs.c
+++ b/drivers/staging/dgrp/dgrp_sysfs.c
@@ -17,7 +17,6 @@
 #include "dgrp_common.h"
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/string.h>

