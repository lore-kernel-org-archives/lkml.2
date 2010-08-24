Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0HXWx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:53:27 -0400
Received: from kroah.org ([198.145.64.141]:52038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab0HXWxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:53:23 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:22 2010
Message-Id: <20100824222522.622625174@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [03/59] ASoC: Remove DSP mode support for WM8776
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b2c1e07b81a126e5846dfc3d36f559d861df59f4 upstream.

This is not supported by current hardware revisions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8776.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/sound/soc/codecs/wm8776.c
+++ b/sound/soc/codecs/wm8776.c
@@ -177,13 +177,6 @@ static int wm8776_set_fmt(struct snd_soc
 	case SND_SOC_DAIFMT_LEFT_J:
 		iface |= 0x0001;
 		break;
-		/* FIXME: CHECK A/B */
-	case SND_SOC_DAIFMT_DSP_A:
-		iface |= 0x0003;
-		break;
-	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x0007;
-		break;
 	default:
 		return -EINVAL;
 	}


