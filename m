Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab1LMEi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 23:38:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55085 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1LMEi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 23:38:26 -0500
MIME-Version: 1.0
In-Reply-To: <20111212100513.GA5017@sirena.org.uk>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
	<1321848532-8784-3-git-send-email-tomoya.rohm@gmail.com>
	<20111121114524.GE3784@opensource.wolfsonmicro.com>
	<CANKRQnivyNXNZPnaUOHwpXpJz+kCz6gOwfqYNwkcOo5EpsSvZQ@mail.gmail.com>
	<20111212100513.GA5017@sirena.org.uk>
Date: Tue, 13 Dec 2011 13:38:25 +0900
Message-ID: <CANKRQng7AgKLYGSbBMbOiWifL6WNPHM=b7cB0FhfuXg74qi1Fg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 3/3] sound/soc/lapis: add platform driver
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>,
        Mike Frysinger <vapier@gentoo.org>, qi.wang@intel.com,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        yong.y.wang@intel.com, kok.howg.ewe@intel.com,
        Daniel Mack <zonque@gmail.com>, Liam Girdwood <lrg@ti.com>,
        joel.clark@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/12 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Dec 12, 2011 at 05:28:13PM +0900, Tomoya MORINAGA wrote:
>
>> struct snd_soc_ops {
>> ...
>> };
>
>> On the other hand, tegra_i2s.c describes like below.
>
>> static const struct snd_soc_dai_ops tegra_i2s_dai_ops = {
>> ...
>> };
>
>> Which is true as modern driver ? or case by case ?
>
> The latter.  With things like this it would be *really* helpful if you
> could take a step back and think about what the differences mean and why
> they are different.

Our driver needs ".pointer" method.
However, "struct snd_soc_dai_ops" doesn't have the method.
So, I think "struct snd_soc_dai_ops" cannot be applied to our driver.
Searching other drivers, "blackfin/bf5xx-i2s-pcm.c" uses "struct
snd_soc_ops" not "struct snd_soc_dai_ops".
Let me know your opinion.

Thanks,

tomoya
