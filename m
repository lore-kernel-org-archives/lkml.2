Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab1KJD06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:26:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934751Ab1KJD0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:26:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:10 2011
Message-Id: <20111109212710.613930295@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [100/262] ASoC: wm8940: Properly set codec->dapm.bias_level
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -472,6 +472,8 @@ static int wm8940_set_bias_level(struct
 		break;
 	}
 
+	codec->dapm.bias_level = level;
+
 	return ret;
 }
 


