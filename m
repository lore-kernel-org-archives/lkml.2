Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1LAHq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:46:56 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33588 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1LAHqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:46:55 -0500
MIME-Version: 1.0
In-Reply-To: <4ED4EE48.8070100@metafoo.de>
References: <1322474755-18785-1-git-send-email-tomoya.rohm@gmail.com>
	<4ED37CE3.6040008@metafoo.de>
	<CANKRQnh7MnSQdKXvPJvSPzf-7afXmHip9LqR1cKCgB6HXqcnBg@mail.gmail.com>
	<4ED4EE48.8070100@metafoo.de>
Date: Thu, 1 Dec 2011 16:46:55 +0900
Message-ID: <CANKRQniP=UUAPbbyoZNvxs16H7QZzS=O9zwt6kJu69u8s8qGTQ@mail.gmail.com>
Subject: Re: [PATCH v3] sound/soc/codecs: add LAPIS Semiconductor ML26124
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
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

2011/11/29 Lars-Peter Clausen <lars@metafoo.de>:
>
> Also this doesn't make much sense:
> +       {"Input Mux", "Analog MIC in", "MICBIAS"},
> +       {"Input Mux", "Digital MIC in", "MICBIAS"},
>
> You have mux, but both possible settings of the mux connect to the same
> source, which pretty much makes the mux useless.
>

Yes, you are right.
This setting was miss-settings.
This MICBIAS supplies to external MIC as reference voltage.
So, I think MICBIAS shouldn't appear at this setting.
I show modified settings.
       /* input */
       {"Input Mux", "Analog MIC SingleEnded in", "MIN"},
       {"Input Mux", "Analog MIC Differential in", "MIN"},
       {"Input Mux", "Digital MIC in", "MDIN"},
       {"ADC", "PGA", "Input Mux"},

Thanks,
------
ROHM Co., Ltd.
Tomoya MORINAGA
