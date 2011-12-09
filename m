Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1LINiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:38:22 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64831 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1LINiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:38:18 -0500
From: =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: alsa-devel@alsa-project.org
Cc: Dong Aisheng-B29396 <B29396@freescale.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        =?utf-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 0/5] ASoC: mxs: Several cleanups and bugfixes for the MXS sound driver
Date: Fri,  9 Dec 2011 14:38:07 +0100
Message-Id: <cover.1323436034.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lothar Waßmann (5):
  General cleanups
  Add .owner to struct snd_soc_card
  Export symbols 'mxs_saif_put_mclk()' and 'mxs_saif_get_mclk()'
  Add missing MODULE_LICENSE("GPL")
  Add appropriate MODULE_ALIAS()

 sound/soc/codecs/sgtl5000.c  |   13 ++++++-------
 sound/soc/mxs/mxs-pcm.c      |    3 +++
 sound/soc/mxs/mxs-saif.c     |    4 +++-
 sound/soc/mxs/mxs-sgtl5000.c |    2 ++
 4 files changed, 14 insertions(+), 8 deletions(-)

