Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0JOKEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:04:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45654 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0JOKE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:04:28 -0400
Subject: Re: [PATCH] ASoC: Add max98088 CODEC driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D469C1251@ITSVLEX06.it.maxim-ic.internal>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 ,<B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C1251@ITSVLEX06.it.maxim-ic.internal>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 11:04:24 +0100
Message-ID: <1287137064.3271.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 20:30 -0700, Peter Hsiang wrote:
> This patch adds the MAX98088 CODEC driver.
> 
> Signed-off-by: Peter Hsiang <peter.hsiang@maxim-ic.com>
> ---
>  include/sound/max98088.h    |   50 +
>  sound/soc/codecs/Kconfig    |    4 +
>  sound/soc/codecs/Makefile   |    2 +
>  sound/soc/codecs/max98088.c | 2097 +++++++++++++++++++++++++++++++++++++++++++
>  sound/soc/codecs/max98088.h |  193 ++++
>  5 files changed, 2346 insertions(+), 0 deletions(-)
>  create mode 100644 include/sound/max98088.h
>  create mode 100644 sound/soc/codecs/max98088.c
>  create mode 100644 sound/soc/codecs/max98088.h
> 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

