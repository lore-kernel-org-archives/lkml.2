Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1LLI2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:28:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50988 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1LLI2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111121114524.GE3784@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
	<1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
	<20111121114524.GE3784@opensource.wolfsonmicro.com>
Date: Mon, 12 Dec 2011 17:28:13 +0900
Message-ID: <CANKRQnivyNXNZPnaUOHwpXpJz+kCz6gOwfqYNwkcOo5EpsSvZQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] sound/soc/lapis: add platform driver
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Searching git log,
tegra_i2s.c seems modern.
I have a question.

According to platfom.txt, describes like below.
struct snd_soc_ops {
...
};

On the other hand, tegra_i2s.c describes like below.

static const struct snd_soc_dai_ops tegra_i2s_dai_ops = {
...
};

Which is true as modern driver ? or case by case ?


>> +#define      I2S_CH0_MCLK            (12288000) /* Master Clock Frequency[Hz] */
> This looks like it should be board specific?
Should our platform driver use "clk_get()" ?
If no, how should our driver get the value ?

thanks in advance.

tomoya
