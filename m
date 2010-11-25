Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0KYHEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:04:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38253 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0KYHEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:04:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pShiEZ3XseVD35UlyP+1MjH5cqerK9rFh7bUkvy8ya+DxW+bmeKBZS1WnoA5XOwdih
         S5v0IAiZghUReS6XsSTsTL7YP//lS6xxzIukAS2TiQIORr+bYy9J4Ik568qSgvgQXIb+
         dvCif0Tp87p8Y5QzcCWcKwi1njo/P2BOxYfgI=
Subject: [PATCH 3/8] ASoC: snd-soc-afeb9260: remove unneeded
	platform_device_del in error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Sergey Lapin <slapin@ossfans.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1290668785.30158.7.camel@mola>
References: <1290668785.30158.7.camel@mola>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:10:01 +0800
Message-Id: <1290669001.30158.13.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f3b1f9a02fe390b2f12b9097a1d4d9de55618b34 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 25 Nov 2010 10:44:59 +0800
Subject: [PATCH 3/8] ASoC: snd-soc-afeb9260: remove unneeded platform_device_del in error path

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/atmel/snd-soc-afeb9260.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/snd-soc-afeb9260.c b/sound/soc/atmel/snd-soc-afeb9260.c
index 1202f5e..da2208e 100644
--- a/sound/soc/atmel/snd-soc-afeb9260.c
+++ b/sound/soc/atmel/snd-soc-afeb9260.c
@@ -167,7 +167,6 @@ static int __init afeb9260_soc_init(void)
 
 	return 0;
 err1:
-	platform_device_del(afeb9260_snd_device);
 	platform_device_put(afeb9260_snd_device);
 	return err;
 }
-- 
1.7.2



