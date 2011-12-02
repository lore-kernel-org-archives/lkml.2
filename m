Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab1LBMf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:35:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58515 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab1LBMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <20111202122205.GL8245@opensource.wolfsonmicro.com>
References: <1321848532-8784-1-git-send-email-tomoya.rohm@gmail.com>
	<1321848532-8784-2-git-send-email-tomoya.rohm@gmail.com>
	<20111121113433.GD3784@opensource.wolfsonmicro.com>
	<CANKRQnjdS1NvcGLa=S1M0D4U_NV3+JR1E4YfAV7Ziq-fE2LQgg@mail.gmail.com>
	<20111202114638.GI8245@opensource.wolfsonmicro.com>
	<CANKRQng5OzqjiQ81OUH+2Aet8DAM198s6B=_1FuASnd19BU26w@mail.gmail.com>
	<20111202122205.GL8245@opensource.wolfsonmicro.com>
Date: Fri, 2 Dec 2011 21:35:57 +0900
Message-ID: <CANKRQnhcA-bzcMnR2BBPStb7XgZp2pe=XE2YjKOMjUKPw2Ms5w@mail.gmail.com>
Subject: Re: [PATCH 2/3] sound/soc/lapis: add machine driver
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

2011/12/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Fri, Dec 02, 2011 at 09:09:34PM +0900, Tomoya MORINAGA wrote:
>> 2011/12/2 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > The CPU side audio drivers are not there - there seemed to be some quite
>> > serious review issues with those.
>
>> Let me clarify your saying.
>> Does the above "audio drivers" mean i2s (of south bridge) driver or HD
>> audio (of north bridge) or another?
>
> I2S and audio DMA.

OK.
As you know, I post i2s/dma driver once. I understand need to do much
modification.
I'm going to develop codec driver, machine driver and
platform(i2s/dma) driver in turn obeying modern ASoC framework.

Do you mean you cannot review this codec driver any more unless I
provide other 2 drivers (machine and platform) ?

Thanks,
tomoya
