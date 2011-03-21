Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1CUXZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:25:03 -0400
Received: from kroah.org ([198.145.64.141]:52724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932369Ab1CUXSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.383333163@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasily Khoruzhick <anarsoul@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [55/78] ASoC: PXA: Z2: Fix codec pin name
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

commit 64c25a92e865f06ad8782fbdaa1e2a97d50acf73 upstream.

MONO was renamed to MONO1.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/pxa/z2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/pxa/z2.c
+++ b/sound/soc/pxa/z2.c
@@ -147,7 +147,7 @@ static int z2_wm8750_init(struct snd_soc
 	snd_soc_dapm_disable_pin(dapm, "LINPUT3");
 	snd_soc_dapm_disable_pin(dapm, "RINPUT3");
 	snd_soc_dapm_disable_pin(dapm, "OUT3");
-	snd_soc_dapm_disable_pin(dapm, "MONO");
+	snd_soc_dapm_disable_pin(dapm, "MONO1");
 
 	/* Add z2 specific widgets */
 	snd_soc_dapm_new_controls(dapm, wm8750_dapm_widgets,


