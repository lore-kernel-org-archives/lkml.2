Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1EZCyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 22:54:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38105 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1EZCyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 22:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DF2d/VxQXa9+mhKuCpsItrLNPrQnJG3rRGAZ+wfhN8Zb9tSX4PArYcGioGxEzZJKGP
         snaZvrDX0VpKqPH0misShZbVfE3cSxKe9oYyyKzWTlOJm/pTJC4zi3QyhfEprnzA4wyw
         4URQ3HnKIJN/gQ0sy7NrJ3z9P5j0tXn/44suw=
Subject: [PATCH] ASoC: wm1250-ev1: Define "WM1250 Output" with
 SND_SOC_DAPM_OUTPUT
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 10:54:12 +0800
Message-ID: <1306378452.10398.9.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Codec output pin should be defined with SND_SOC_DAPM_OUTPUT.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Note: 
Just found this bug while reading the code.
I don't have this hardware handy. I appreciate if someone can test it.

Axel

 sound/soc/codecs/wm1250-ev1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm1250-ev1.c b/sound/soc/codecs/wm1250-ev1.c
index 14d0716..bcc2089 100644
--- a/sound/soc/codecs/wm1250-ev1.c
+++ b/sound/soc/codecs/wm1250-ev1.c
@@ -22,7 +22,7 @@ SND_SOC_DAPM_ADC("ADC", "wm1250-ev1 Capture", SND_SOC_NOPM, 0, 0),
 SND_SOC_DAPM_DAC("DAC", "wm1250-ev1 Playback", SND_SOC_NOPM, 0, 0),
 
 SND_SOC_DAPM_INPUT("WM1250 Input"),
-SND_SOC_DAPM_INPUT("WM1250 Output"),
+SND_SOC_DAPM_OUTPUT("WM1250 Output"),
 };
 
 static const struct snd_soc_dapm_route wm1250_ev1_dapm_routes[] = {
-- 
1.7.1



