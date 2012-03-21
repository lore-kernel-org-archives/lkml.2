Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab2CUAwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:52:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62717 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2CUAv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120319192101.GG12384@opensource.wolfsonmicro.com>
References: <CANKRQni1k4hv40j0hTzVMdS9aFccM7xRrHis0-cFuBvSZe+9CA@mail.gmail.com>
	<1332158525-14968-1-git-send-email-tomoya.rohm@gmail.com>
	<20120319192101.GG12384@opensource.wolfsonmicro.com>
Date: Wed, 21 Mar 2012 09:51:58 +0900
Message-ID: <CANKRQniytxNLHdkCDF5W4ZZHxo7w5WJgtYh1036x7DNBe4h2ZA@mail.gmail.com>
Subject: Re: [PATCH v7] sound/soc/lapis: add machine driver for ML7213 Carrier Board
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, lars@metafoo.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 4:21 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>> +     snd_soc_dapm_enable_pin(dapm, "Speaker");
>> +     snd_soc_dapm_enable_pin(dapm, "AnalogMIC");
>> +     snd_soc_dapm_enable_pin(dapm, "MICBIAS");
>
> Why are you doing thiS?  You never disable these things so if this were
> needed you may as well do it on init, but since the default state is
> enabled anyway this shouldn't be doing anytihng.

OK.
I've confirmed if deleting these lines, both playback/capture work well.
So, I'll delete these.

thanks.
-- 
ROHM Co., Ltd.
tomoya
