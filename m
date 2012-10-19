Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030239Ab2JSCtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:52702 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201Ab2JSCtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 74/76] ASoC: omap-abe-twl6040: Fix typo of Vibrator
Date: Thu, 18 Oct 2012 19:47:38 -0700
Message-Id: <20121019024402.015050533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

commit 034940a6b3afbe79022ab6922dd9d2982b78e6d5 upstream.

It is not Vinrator but Vibrator.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/omap/omap-abe-twl6040.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/omap/omap-abe-twl6040.c
+++ b/sound/soc/omap/omap-abe-twl6040.c
@@ -190,7 +190,7 @@ static int omap_abe_twl6040_init(struct
 	twl6040_disconnect_pin(dapm, pdata->has_hf, "Ext Spk");
 	twl6040_disconnect_pin(dapm, pdata->has_ep, "Earphone Spk");
 	twl6040_disconnect_pin(dapm, pdata->has_aux, "Line Out");
-	twl6040_disconnect_pin(dapm, pdata->has_vibra, "Vinrator");
+	twl6040_disconnect_pin(dapm, pdata->has_vibra, "Vibrator");
 	twl6040_disconnect_pin(dapm, pdata->has_hsmic, "Headset Mic");
 	twl6040_disconnect_pin(dapm, pdata->has_mainmic, "Main Handset Mic");
 	twl6040_disconnect_pin(dapm, pdata->has_submic, "Sub Handset Mic");


