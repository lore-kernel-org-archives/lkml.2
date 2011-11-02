Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093Ab1KCBoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:44:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934941Ab1KCBoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:44:01 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.902859319@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [078/101] ASoC: ak4535: fixup cache register table
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 7c04241acbdaf97f1448dcccd27ea0fcd1a57684 upstream.

ak4535_reg should be 8bit, but cache table is defined as 16bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/ak4535.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -40,11 +40,11 @@ struct ak4535_priv {
 /*
  * ak4535 register cache
  */
-static const u16 ak4535_reg[AK4535_CACHEREGNUM] = {
-    0x0000, 0x0080, 0x0000, 0x0003,
-    0x0002, 0x0000, 0x0011, 0x0001,
-    0x0000, 0x0040, 0x0036, 0x0010,
-    0x0000, 0x0000, 0x0057, 0x0000,
+static const u8 ak4535_reg[AK4535_CACHEREGNUM] = {
+	0x00, 0x80, 0x00, 0x03,
+	0x02, 0x00, 0x11, 0x01,
+	0x00, 0x40, 0x36, 0x10,
+	0x00, 0x00, 0x57, 0x00,
 };
 
 /*


