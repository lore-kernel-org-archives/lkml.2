Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1LGEms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 23:42:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746Ab1LGEmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 23:42:45 -0500
MIME-Version: 1.0
In-Reply-To: <CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
	<CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
	<20111205183223.GB7467@opensource.wolfsonmicro.com>
	<CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
Date: Wed, 7 Dec 2011 13:42:45 +0900
Message-ID: <CANKRQnhbBNDjQw5MQGexZAEboC0oHB5QS1LfHo6pDeoeDSwByw@mail.gmail.com>
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

2011/12/6 Tomoya MORINAGA <tomoya.rohm@gmail.com>:
>>> >> +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
>>> >> +                             SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>>> >> +     if (ret < 0)
>>> >> +             return ret;
>>
>>> > Use the dai_fmt field in the dai_link to set this.
>>
>>> Sorry, I can't understand your saying.
>>> Let me know in more detail.
>>
>> I'm not sure what more to say...  Have you looked at that field and how
>> it is both implemented and used in other drivers, or at the commit logs
>> for relevant changes?  What do you find unclear?
>
> You said "Use the dai_fmt field in the dai_link to set this."
> However, both dai_fmt and dai_link are already implemented like below.
> static struct snd_soc_dai_link ioh_i2s_dai = {
> ...
> };
>
> static struct snd_soc_card ioh_i2s_card = {
> ...
>        .dai_link       = &ioh_i2s_dai,
> ...
> };
> So, I can't understand your saying.

Could you give me your answer ?

thanks,

tomoya
