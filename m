Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1AFA3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:14 -0500
Received: from kroah.org ([198.145.64.141]:35472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1AFA3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:10 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.132070635@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Uk Kim <w0806.kim@samsung.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [026/152] ASoC: Fix off by one error in WM8994 EQ register bank size
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uk Kim <w0806.kim@samsung.com>

commit 3fcc0afbb9c93f3599ba03273e59915670b6c2c2 upstream.

Signed-off-by: Uk Kim <w0806.kim@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/mfd/wm8994/pdata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -29,7 +29,7 @@ struct wm8994_ldo_pdata {
 #define WM8994_CONFIGURE_GPIO 0x8000
 
 #define WM8994_DRC_REGS 5
-#define WM8994_EQ_REGS  19
+#define WM8994_EQ_REGS  20
 
 /**
  * DRC configurations are specified with a label and a set of register


