Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab2KZRqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:46:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47710 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933260Ab2KZRJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:22 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 152/270] ASoC: wm2200: Use rev A register patches on rev B
Date: Mon, 26 Nov 2012 14:57:22 -0200
Message-Id: <1353949160-26803-153-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 5ae9eb4cbdfd640269dbd66aa3c92ea8e11cc838 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm2200.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wm2200.c b/sound/soc/codecs/wm2200.c
index 32682c1..58ab97a 100644
--- a/sound/soc/codecs/wm2200.c
+++ b/sound/soc/codecs/wm2200.c
@@ -2091,6 +2091,7 @@ static __devinit int wm2200_i2c_probe(struct i2c_client *i2c,
 
 	switch (wm2200->rev) {
 	case 0:
+	case 1:
 		ret = regmap_register_patch(wm2200->regmap, wm2200_reva_patch,
 					    ARRAY_SIZE(wm2200_reva_patch));
 		if (ret != 0) {
-- 
1.7.9.5

