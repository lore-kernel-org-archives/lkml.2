Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab2BJWll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:41:41 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2BJWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:38 -0500
MIME-Version: 1.0
Message-Id: <20120210222945.937952763@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, UK KIM <w0806.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 10/86] ASoC: wm_hubs: fix wrong bits for LINEOUT2 N/P mixer
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: UK KIM <w0806.kim@samsung.com>

commit 114395c61ad2eb5a7a5cd163fcadb2414e48245a upstream.

Signed-off-by: UK KIM <w0806.kim@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -593,8 +593,8 @@ SOC_DAPM_SINGLE("Output Switch", WM8993_
 };
 
 static const struct snd_kcontrol_new line2n_mix[] = {
-SOC_DAPM_SINGLE("Left Output Switch", WM8993_LINE_MIXER2, 6, 1, 0),
-SOC_DAPM_SINGLE("Right Output Switch", WM8993_LINE_MIXER2, 5, 1, 0),
+SOC_DAPM_SINGLE("Left Output Switch", WM8993_LINE_MIXER2, 5, 1, 0),
+SOC_DAPM_SINGLE("Right Output Switch", WM8993_LINE_MIXER2, 6, 1, 0),
 };
 
 static const struct snd_kcontrol_new line2p_mix[] = {


