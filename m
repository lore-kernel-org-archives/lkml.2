Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1BBAn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:1497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab1BBAnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504909"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: w0806.kim@samsung.com, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [21/139] ASoC: Fix off by one error in WM8994 EQ register bank size
Message-Id: <20110202004335.C82EE3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Uk Kim <w0806.kim@samsung.com>

commit 3fcc0afbb9c93f3599ba03273e59915670b6c2c2 upstream.

Signed-off-by: Uk Kim <w0806.kim@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/mfd/wm8994/pdata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/include/linux/mfd/wm8994/pdata.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/mfd/wm8994/pdata.h
+++ linux-2.6.35.y/include/linux/mfd/wm8994/pdata.h
@@ -29,7 +29,7 @@ struct wm8994_ldo_pdata {
 #define WM8994_CONFIGURE_GPIO 0x8000
 
 #define WM8994_DRC_REGS 5
-#define WM8994_EQ_REGS  19
+#define WM8994_EQ_REGS  20
 
 /**
  * DRC configurations are specified with a label and a set of register
