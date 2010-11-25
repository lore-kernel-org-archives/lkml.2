Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab0KYHBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:01:14 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56785 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0KYHBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JtlflQunuRGdmfRFsQOU5/K4Gc+J+UGIccdmwZdF2tmQLsIVQFTUDd0YTBo0FGvoUh
         a9BjOP51ThZWpLuRmrkbB/PkjQ6jsyHH/Sn7lMXDz9dJHkcBC4Zpj1pJI2pIyOPabhbD
         RhJhdK4SgHzFNUlqTrvjb1nc790INxP7OW2dg=
Subject: [PATCH 0/8] ASoC: fix resource leak in error paths
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Jon Smirl <jonsmirl@gmail.com>,
        Sergey Lapin <slapin@ossfans.org>,
        Sedji Gaouaou <sedji.gaouaou@atmel.com>,
        Jaswinder Singh Brar <jassi.brar@samsung.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain
Date: Thu, 25 Nov 2010 15:06:25 +0800
Message-Id: <1290668785.30158.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial of patches fix resource leak in error paths.

Axel Lin (8):
  ASoC: efika-audio-fabric: fix resource leak in efika_fabric_init
    error path
  ASoC: pcm030-audio-fabric: fix resource leak in pcm030_fabric_init
    error path
  ASoC: snd-soc-afeb9260: remove unneeded platform_device_del in error
    path
  ASoC: sam9g20_wm8731: fix resource leak in at91sam9g20ek_init error
    path
  ASoC: smdk_wm9713: fix resource leak in smdk_init error path
  ASoC: simone: fix resource leak in simone_init error path
  ASoC: imx-ssi: fix resource leak
  ASoC: phycore-ac97: fix resource leak

 sound/soc/atmel/sam9g20_wm8731.c    |    5 ++++-
 sound/soc/atmel/snd-soc-afeb9260.c  |    1 -
 sound/soc/ep93xx/simone.c           |   18 ++++++++++--------
 sound/soc/fsl/efika-audio-fabric.c  |    1 +
 sound/soc/fsl/pcm030-audio-fabric.c |    1 +
 sound/soc/imx/imx-ssi.c             |   15 +++++++++++----
 sound/soc/imx/phycore-ac97.c        |   28 +++++++++++++++++++++-------
 sound/soc/samsung/smdk_wm9713.c     |   17 ++++++++++-------
 8 files changed, 58 insertions(+), 28 deletions(-)

-- 
1.7.2



