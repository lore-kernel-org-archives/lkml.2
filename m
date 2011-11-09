Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936041Ab1KJEMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:12:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965566Ab1KJDnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:43:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:54 2011
Message-Id: <20111109213154.295952857@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [121/264] ASoC: wm8940: Properly set codec->dapm.bias_level
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -470,6 +470,8 @@ static int wm8940_set_bias_level(struct
 		break;
 	}
 
+	codec->dapm.bias_level = level;
+
 	return ret;
 }
 


