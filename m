Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801Ab2BJW6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:58:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab2BJWoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:55 -0500
MIME-Version: 1.0
Message-Id: <20120210223443.537526438@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:33:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 37/55] ASoC: wm_hubs: Correct line input to line output 2 paths
In-Reply-To: <20120210223500.GA24178@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 43b6cec27e1e50a1de3eff47e66e502f3fe7e66e upstream.

The second line output mixer has the controls for the line input bypasses
in the opposite order.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_hubs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -562,8 +562,8 @@ SOC_DAPM_SINGLE("Left Output Switch", WM
 };
 
 static const struct snd_kcontrol_new line2_mix[] = {
-SOC_DAPM_SINGLE("IN1R Switch", WM8993_LINE_MIXER2, 2, 1, 0),
-SOC_DAPM_SINGLE("IN1L Switch", WM8993_LINE_MIXER2, 1, 1, 0),
+SOC_DAPM_SINGLE("IN1L Switch", WM8993_LINE_MIXER2, 2, 1, 0),
+SOC_DAPM_SINGLE("IN1R Switch", WM8993_LINE_MIXER2, 1, 1, 0),
 SOC_DAPM_SINGLE("Output Switch", WM8993_LINE_MIXER2, 0, 1, 0),
 };
 


