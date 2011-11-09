Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550Ab1KJDnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:43:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518Ab1KJDnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.586632222@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [124/264] ASoC: ak4535: fixup cache register table
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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


