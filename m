Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2JSCwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:52:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:52672 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030195Ab2JSCtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 72/76] ASoC: wm2200: Use rev A register patches on rev B
Date: Thu, 18 Oct 2012 19:47:36 -0700
Message-Id: <20121019024401.700153074@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 5ae9eb4cbdfd640269dbd66aa3c92ea8e11cc838 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm2200.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -2091,6 +2091,7 @@ static __devinit int wm2200_i2c_probe(st
 
 	switch (wm2200->rev) {
 	case 0:
+	case 1:
 		ret = regmap_register_patch(wm2200->regmap, wm2200_reva_patch,
 					    ARRAY_SIZE(wm2200_reva_patch));
 		if (ret != 0) {


