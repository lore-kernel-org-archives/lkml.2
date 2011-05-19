Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232Ab1ESSRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:17:05 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46892 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933907Ab1ESSIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:47 -0400
X-Sasl-enc: VyfDmLH8zIS7j1isqHZPlkvFdw/xkIXdS0rKCqo+0mXi 1305828526
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:58 2011
Message-Id: <20110519180558.149946223@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [40/71] ASoC: SSM2602: Fix Mic Boost2 control
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 36c90ab33feabbd63da775bd92ad356e5bd5cf56 upstream.

The 'Mic Boost2' control's shift was off by one and thus was not working.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ssm2602.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -139,7 +139,7 @@ SOC_DOUBLE_R("Capture Volume", SSM2602_L
 SOC_DOUBLE_R("Capture Switch", SSM2602_LINVOL, SSM2602_RINVOL, 7, 1, 1),
 
 SOC_SINGLE("Mic Boost (+20dB)", SSM2602_APANA, 0, 1, 0),
-SOC_SINGLE("Mic Boost2 (+20dB)", SSM2602_APANA, 7, 1, 0),
+SOC_SINGLE("Mic Boost2 (+20dB)", SSM2602_APANA, 8, 1, 0),
 SOC_SINGLE("Mic Switch", SSM2602_APANA, 1, 1, 1),
 
 SOC_SINGLE("Sidetone Playback Volume", SSM2602_APANA, 6, 3, 1),


