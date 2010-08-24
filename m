Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053Ab0HXXYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:24:33 -0400
Received: from kroah.org ([198.145.64.141]:40783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220Ab0HXXBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:01:06 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:01 2010
Message-Id: <20100824224501.718969126@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:44:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [005/114] ASoC: Remove DSP mode support for WM8776
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

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
@@ -178,13 +178,6 @@ static int wm8776_set_fmt(struct snd_soc
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


