Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab1LEF2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:28:31 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40899 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab1LEF2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:28:30 -0500
MIME-Version: 1.0
In-Reply-To: <20111202153401.GX8245@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
Date: Mon, 5 Dec 2011 14:28:29 +0900
Message-ID: <CANKRQngGHLD0Bam6sxCGPSkGutjkagbJMvGPTgkduXR6xmMw_Q@mail.gmail.com>
Subject: Re: [PATCH v2] soc/lapis: add machine driver
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

First of all, let me confirm my understanding for machine driver.
According to "machine.txt", I created this machine driver referring
corgi.c/spitz.c.
However, corgi.c/spitz.c. don't look obeying your saying.

e.g.
2011/12/3 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>> +     snd_soc_dapm_add_routes(dapm, ml7213_routes, ARRAY_SIZE(ml7213_routes));
>
> Use table based init for these.
>
I  couldn't see any table based init processing at corgi.c/spitz.c.

>
>> +     switch (params_rate(params)) {
>> +     case 16000:
>> +     case 32000:
>> +     case 48000:
>> +             clk = 12288800;
>> +             break;
>
> You may as well just set the CODEC clock rate once on init() and let the
> CODEC driver worry about what it can do with the clock it's got, if the
> values aren't going to change there's no need to set them every time.
>

corgi.c/spitz.c look coded like above.

So, I'm confused.
Is this procedure true ?


Thanks,

tomoya
