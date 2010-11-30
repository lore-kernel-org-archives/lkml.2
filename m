Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab0K3BkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 20:40:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41647 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab0K3BkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 20:40:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=f6ZN5T6DsR66yi/aIc2gC20MUaVnKPupxoGS3AhYWNfwxANWut62J2G+v1PZYNYgWB
         hxQgTD0RoeSWYJgW9No09gnYmnUuOZWyJyP/pyFa5wUnz/uz3Gnx29ICatGS7KMXC0au
         k8dXJ7s0tpDxmSQe+8vMRDy87V1pIr+5Zj0i8=
Subject: [PATCH] ASoC: Fix compile error for s6000-i2s.c by adding a
	missing ';' character
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: dg@emlix.com, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Tue, 30 Nov 2010 09:45:53 +0800
Message-Id: <1291081553.18485.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have toolchain to compile s6000, I'm not able to put the error message in the commit log.
But I know this patch indeed fixes a compile error.

 sound/soc/s6000/s6000-i2s.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/s6000/s6000-i2s.c b/sound/soc/s6000/s6000-i2s.c
index 8778faa..3052f64 100644
--- a/sound/soc/s6000/s6000-i2s.c
+++ b/sound/soc/s6000/s6000-i2s.c
@@ -434,7 +434,7 @@ static struct snd_soc_dai_driver s6000_i2s_dai = {
 		.rate_max = 1562500,
 	},
 	.ops = &s6000_i2s_dai_ops,
-}
+};
 
 static int __devinit s6000_i2s_probe(struct platform_device *pdev)
 {
-- 
1.7.2



