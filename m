Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab0G3R5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:57:37 -0400
Received: from kroah.org ([198.145.64.141]:58700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932589Ab0G3R4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:43 2010
Message-Id: <20100730175143.631631912@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [108/205] ASoC: Remove duplicate AUX definition from WM8776
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3c0709396df0869786f83e4b2d2d687c70ee886d upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8776.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/wm8776.c
+++ b/sound/soc/codecs/wm8776.c
@@ -94,7 +94,6 @@ SOC_DAPM_SINGLE("Bypass Switch", WM8776_
 
 static const struct snd_soc_dapm_widget wm8776_dapm_widgets[] = {
 SND_SOC_DAPM_INPUT("AUX"),
-SND_SOC_DAPM_INPUT("AUX"),
 
 SND_SOC_DAPM_INPUT("AIN1"),
 SND_SOC_DAPM_INPUT("AIN2"),


