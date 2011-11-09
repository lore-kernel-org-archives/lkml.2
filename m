Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936266Ab1KJENF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:13:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965545Ab1KJDnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.788091133@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [126/264] ASoC: wm8994: Fix setting rate_reg for wm8994-aif2
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit c527e6aadc8f142ad388b6aa59a1ce6a4bfb1966 upstream.

For wm8994-aif2, the rate_reg should be WM8994_AIF2_RATE.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2311,7 +2311,7 @@ static void wm8994_aif_shutdown(struct s
 		rate_reg = WM8994_AIF1_RATE;
 		break;
 	case 2:
-		rate_reg = WM8994_AIF1_RATE;
+		rate_reg = WM8994_AIF2_RATE;
 		break;
 	default:
 		break;


