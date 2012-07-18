Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab2GROdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:33:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41946 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab2GROdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:33:47 -0400
Message-ID: <5006C942.2020800@gmail.com>
Date: Wed, 18 Jul 2012 22:33:38 +0800
From: Duan Jiong <djduanjiong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org, alan@linux.intel.com
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sep_crypto.c: remove duplicated include
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Duan Jiong <djduanjiong@gmail.com>
---
 drivers/staging/sep/sep_crypto.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index 1cc790e..1d97e5a 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -44,7 +44,6 @@
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <linux/pci.h>
-#include <linux/pci.h>
 #include <linux/pm_runtime.h>
 #include <linux/err.h>
 #include <linux/device.h>
-- 
1.7.9.5

