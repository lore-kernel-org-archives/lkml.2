Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1KCBgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933421Ab1KCBgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:56 2011
Message-Id: <20111102221456.883229624@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [074/107] ASoC: wm8940: Properly set codec->dapm.bias_level
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 5927f94700e860ae27ff24e7f3bc9e4f7b9922eb upstream.

Reported-by: Chris Paulson-Ellis <chris@edesix.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8940.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -473,6 +473,8 @@ static int wm8940_set_bias_level(struct
 		break;
 	}
 
+	codec->dapm.bias_level = level;
+
 	return ret;
 }
 


