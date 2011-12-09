Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab1LIJpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 04:45:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65415 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab1LIJpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 04:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111209084337.GJ26952@opensource.wolfsonmicro.com>
References: <1322819115-15808-1-git-send-email-tomoya.rohm@gmail.com>
	<20111202153401.GX8245@opensource.wolfsonmicro.com>
	<CANKRQniyjT_2Ko=EYmffu3_NzDJQTMm9nY6rUp-DQ70e6AVQpA@mail.gmail.com>
	<20111205183223.GB7467@opensource.wolfsonmicro.com>
	<CANKRQnhEFvubv0b63z34=_xn4x4q=20enofqPrMsFetj1x7-NQ@mail.gmail.com>
	<CANKRQnhbBNDjQw5MQGexZAEboC0oHB5QS1LfHo6pDeoeDSwByw@mail.gmail.com>
	<20111207132322.GA18837@opensource.wolfsonmicro.com>
	<CANKRQniJR+b1gUwZUUiPoNDKVqU7TCkThLaHL2DFXAF=cARrTA@mail.gmail.com>
	<20111209084337.GJ26952@opensource.wolfsonmicro.com>
Date: Fri, 9 Dec 2011 18:37:40 +0900
Message-ID: <CANKRQnhNJaiQvzBBy10oBV_=TP+rxtPXE-cX=8uMsgXY6qrN+A@mail.gmail.com>
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

2011/12/9 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Dec 09, 2011 at 05:38:57PM +0900, Tomoya MORINAGA wrote:
>
>> Firstly, the above "dai_link structure" means below ? If yes, there is
>> no member "dai_fmt", right ?
>> 697 struct snd_soc_dai_link {
>
> As previously advised you should work against current development
> kernels.  dai_fmt is present in current development kernels (and Linus'
> tree for that matter).
>
>> > +     ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
>> > +                             SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS);
>
>> At the above point, do you mean I shouldn't  set these formats(
>> SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBS_CFS)
>> directly ?
>
> Yes.

Seeing linux-next tree, I could understand your saying.
I saw linux tree(3.2-rc4).

thanks,
tomoya
