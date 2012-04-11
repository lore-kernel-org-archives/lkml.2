Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab2DKXO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:14:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605Ab2DKXOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:14:54 -0400
Message-Id: <20120411231019.736962400@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 09/78] ASoC: wm8994: Update WM8994 DCS calibration
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit e16605855d58803fe0608417150c7a618b4f8243 upstream.

Based on latest production information.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3427,7 +3427,7 @@ static int wm8994_codec_probe(struct snd
 		case 2:
 		case 3:
 			wm8994->hubs.dcs_codes_l = -9;
-			wm8994->hubs.dcs_codes_r = -5;
+			wm8994->hubs.dcs_codes_r = -7;
 			break;
 		default:
 			break;


