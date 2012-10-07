Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2JGN3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:29:30 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53874 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2JGN3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:29:21 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:29:21 +0800
Message-ID: <CAPgLHd_rNn_bJ8BJOwcq8EmEi-BQcoakHmQpHG+NdOdDgPSMpQ@mail.gmail.com>
Subject: [PATCH] spi: omap2-mcspi: remove duplicated include from spi-omap2-mcspi.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@secretlab.ca, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
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
 drivers/spi/spi-omap2-mcspi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 474e217..b8b2f03 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -39,7 +39,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/pinctrl/consumer.h>
-#include <linux/err.h>
 
 #include <linux/spi/spi.h>
 

