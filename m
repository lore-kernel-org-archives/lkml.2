Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1I0MjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:39:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48374 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1I0MjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:39:00 -0400
Subject: [PATCH 0/6] ASoC: Remove unused control_data field from private
 struct
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 20:38:48 +0800
Message-ID: <1317127128.7207.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial removes unused control_data field from private struct.
The control_data field is used to initialize the codec's control_data field,
but since this is also done by the snd-soc-cache core, the redundant
assignment can be removed and the field can be dropped.

Note: I don't have these hardware, only compile test on these patches.

Axel Lin (6):
  ASoC: Remove unused "control_data" field of struct wm8904_priv
  ASoC: Remove unused "control_data" field of struct wm8940_priv
  ASoC: Remove unused "control_data" field of struct wm8960_priv
  ASoC: Remove unused "control_data" field of struct wm8978_priv
  ASoC: Remove unused "control_data" field of struct wm9081_priv
  ASoC: Remove unused "control_data" field of struct wm9090_priv

 sound/soc/codecs/wm8904.c |    2 --
 sound/soc/codecs/wm8940.c |    3 ---
 sound/soc/codecs/wm8960.c |    3 ---
 sound/soc/codecs/wm8978.c |    3 ---
 sound/soc/codecs/wm9081.c |    3 ---
 sound/soc/codecs/wm9090.c |    3 ---
 6 files changed, 0 insertions(+), 17 deletions(-)

-- 
1.7.4.1



