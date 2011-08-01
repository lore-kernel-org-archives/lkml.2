Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1HAXdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:33:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab1HAX02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:26:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:55 2011
Message-Id: <20110801232055.335072310@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [47/70] ASoC: Fix shift in WM8958 accessory detection default
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 implementation

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b35e160a111aa9ae3fad6294e038be20d0da721b upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8994.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3021,7 +3021,7 @@ static void wm8958_default_micdet(u16 st
 	report = SND_JACK_MICROPHONE;
 
 	/* Everything else is buttons; just assign slots */
-	if (status & 0x1c0)
+	if (status & 0x1c)
 		report |= SND_JACK_BTN_0;
 
 done:


