Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298Ab1JFXnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:43:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62009 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1JFXnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:43:51 -0400
Subject: [PATCH 00/11 v2] Convert wm8xxx codec drivers to use
 snd_soc_write/snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 07:43:39 +0800
Message-ID: <1317944619.5579.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serial converts the wm8xxx codec drivers to use snd_soc_cache_sync.
I don't have these hardware, but I assume Mark has all these hardware.
These patches are UNTESTED. I'd appreciate if someone can test it.
(Current code is broken anyway, thus we need convert to use new API. )

v2: For 7, 9 CODECs that are write only, convert to using cache_bypass + snd_soc_write
    v2 also includes wm8990 that I had sent separately.

*** BLURB HERE ***

Axel Lin (11):
  ASoC: wm8510: Convert to snd_soc_write
  ASoC: wm8711: Convert to snd_soc_write
  ASoC: wm8731: Convert to snd_soc_write
  ASoC: wm8750: Convert to snd_soc_write
  ASoC: wm8776: Convert to snd_soc_write
  ASoC: wm8940: Convert to snd_soc_cache_sync
  ASoC: wm8960: Convert to snd_soc_write
  ASoC: wm8971: Convert to snd_soc_write
  ASoC: wm8974: Convert to snd_soc_write
  ASoC: wm8988: Convert to snd_soc_write
  ASoC: wm8990: Convert to snd_soc_cache_sync

 sound/soc/codecs/wm8510.c |   33 +++++++++++++++++++++----------
 sound/soc/codecs/wm8711.c |   33 +++++++++++++++++++++----------
 sound/soc/codecs/wm8731.c |   35 +++++++++++++++++++++------------
 sound/soc/codecs/wm8750.c |   36 +++++++++++++++++++++-------------
 sound/soc/codecs/wm8776.c |   36 +++++++++++++++++++++-------------
 sound/soc/codecs/wm8940.c |   46 +++++++++++++++++++++-----------------------
 sound/soc/codecs/wm8960.c |   34 +++++++++++++++++++++++---------
 sound/soc/codecs/wm8971.c |   35 ++++++++++++++++++++++-----------
 sound/soc/codecs/wm8974.c |   33 +++++++++++++++++++++----------
 sound/soc/codecs/wm8988.c |   37 +++++++++++++++++++++--------------
 sound/soc/codecs/wm8990.c |   32 ++++++++++++++++++------------
 11 files changed, 242 insertions(+), 148 deletions(-)

-- 
1.7.4.1



