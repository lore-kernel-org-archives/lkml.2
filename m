Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1LAH5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:57:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41383 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1LAH5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <s5hhb1kvix5.wl%tiwai@suse.de>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
	<20111128132317.GD8275@opensource.wolfsonmicro.com>
	<CANKRQng3YtYZggVWp3BWyaWyaHAbN1hccJksWELnv2co37rEcQ@mail.gmail.com>
	<20111129122916.GM2851@opensource.wolfsonmicro.com>
	<CANKRQnjpYDJWfJO-G5HsE6es7metHeqgP32R3eo99MaE2zdNpQ@mail.gmail.com>
	<s5hhb1kvix5.wl%tiwai@suse.de>
Date: Thu, 1 Dec 2011 16:57:52 +0900
Message-ID: <CANKRQniRonz5UcQ-KgnFJptPkqgWWrJsFuW31f8bWCf_xx-tTA@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pB17w39D018722

2011/12/1 Takashi Iwai <tiwai@suse.de>:
> You need to have read Mark's comment carefully.  He quoted another
> line before that.
>
> ================================================================
>> +     SOC_SINGLE_TLV("EQ Band1 Input Volume", ML26124_EQ_GAIN_BRAND1, 0,
>> +                     0xff, 1, eq_band_gain),
>
>> +     SOC_SINGLE("EQ BAND1 Switch", ML26124_FILTER_EN, 3, 1, 0),
>
> These should mathc.
> ================================================================
>
> So, you have two inconsistent names for EQ band1.
>

You mean "EQ Band1" and "EQ BAND1" are inconsistent names ?
If yes, can you accept the followings ?

EQ Band1 Input Volume
EQ Band1 Switch

Thanks,

------
tomoya
ROHM Co., Ltd.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
