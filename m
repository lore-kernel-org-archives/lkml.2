Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab1JBJn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 05:43:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46155 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1JBJnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 05:43:23 -0400
Subject: [PATCH 3/3] ASoC: Staticise sh4_ssi_dai
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317548500.16362.0.camel@phoenix>
References: <1317548500.16362.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Oct 2011 17:43:16 +0800
Message-ID: <1317548596.16362.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/sh/ssi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/sh/ssi.c b/sound/soc/sh/ssi.c
index 05192d9..e0c621c 100644
--- a/sound/soc/sh/ssi.c
+++ b/sound/soc/sh/ssi.c
@@ -342,7 +342,7 @@ static struct snd_soc_dai_ops ssi_dai_ops = {
 	.set_fmt	= ssi_set_fmt,
 };
 
-struct snd_soc_dai_driver sh4_ssi_dai[] = {
+static struct snd_soc_dai_driver sh4_ssi_dai[] = {
 {
 	.name			= "ssi-dai.0",
 	.playback = {
-- 
1.7.4.1



