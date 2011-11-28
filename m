Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1K1JoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:44:07 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48028 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab1K1JoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:44:05 -0500
MIME-Version: 1.0
In-Reply-To: <20111125142858.GE5315@opensource.wolfsonmicro.com>
References: <1322224743-15671-1-git-send-email-tomoya.rohm@gmail.com>
	<20111125142858.GE5315@opensource.wolfsonmicro.com>
Date: Mon, 28 Nov 2011 18:44:04 +0900
Message-ID: <CANKRQnjf6x6GJhFoE+VYRG-=T=vtWDhNgjuED0zGcEEGDA7y0A@mail.gmail.com>
Subject: Re: [PATCH v2] sound/soc/codecs: add LAPIS Semiconductor ML26124
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

2011/11/25 Mark Brown <broonie@opensource.wolfsonmicro.com>: wrote
>
>> +static const struct snd_kcontrol_new ml26124_snd_controls[] = {
>> +     SOC_SINGLE_TLV("Capture Digital Volume", ML26124_RECORD_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
>> +     SOC_SINGLE_TLV("Playback Digital Volume", ML26124_PLBAK_DIG_VOL, 0, 0xff, 1, rec_play_digi_vol),
>
>> +     SOC_SINGLE("Digital Volume Switch", ML26124_FILTER_EN, 4, 1, 0),
>
> This needs either a Playback or Capture in there to match up with the
> above unless it genuinely does mute both which would be really weird.
>

Digital Volume Switch is used for both Playback and Capture.

Regards,
tomoya
