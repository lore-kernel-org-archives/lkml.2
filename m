Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1AFA7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:59:20 -0500
Received: from kroah.org ([198.145.64.141]:35480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab1AFA3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:11 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:59 2011
Message-Id: <20110106002259.219468534@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seungwhan Youn <sw.youn@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [027/152] ASoC: WM8580: Fix R8 initial value
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seungwhan Youn <sw.youn@samsung.com>

commit a0968628097380be52db8b4664da98fc425546a5 upstream.

Acc to WM8580 manual, the default value for R8 is 0x10, not 0x1c.

Signed-off-by: Seungwhan Youn <sw.youn@samsung.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8580.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -171,7 +171,7 @@
 static const u16 wm8580_reg[] = {
 	0x0121, 0x017e, 0x007d, 0x0014, /*R3*/
 	0x0121, 0x017e, 0x007d, 0x0194, /*R7*/
-	0x001c, 0x0002, 0x0002, 0x00c2, /*R11*/
+	0x0010, 0x0002, 0x0002, 0x00c2, /*R11*/
 	0x0182, 0x0082, 0x000a, 0x0024, /*R15*/
 	0x0009, 0x0000, 0x00ff, 0x0000, /*R19*/
 	0x00ff, 0x00ff, 0x00ff, 0x00ff, /*R23*/


