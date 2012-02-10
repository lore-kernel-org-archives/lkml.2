Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944Ab2BJXMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:12:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42369 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab2BJWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:36 -0500
MIME-Version: 1.0
Message-Id: <20120210222950.189323418@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Susan Gao <sgao@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 58/86] ASoC: wm8962: Fix word length configuration
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Susan Gao <sgao@opensource.wolfsonmicro.com>

commit 2b6712b19531e22455e7fa18371c5ba9eec76699 upstream.

Signed-off-by: Susan Gao <sgao@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8962.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -3172,13 +3172,13 @@ static int wm8962_hw_params(struct snd_p
 	case SNDRV_PCM_FORMAT_S16_LE:
 		break;
 	case SNDRV_PCM_FORMAT_S20_3LE:
-		aif0 |= 0x40;
+		aif0 |= 0x4;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
-		aif0 |= 0x80;
+		aif0 |= 0x8;
 		break;
 	case SNDRV_PCM_FORMAT_S32_LE:
-		aif0 |= 0xc0;
+		aif0 |= 0xc;
 		break;
 	default:
 		return -EINVAL;


