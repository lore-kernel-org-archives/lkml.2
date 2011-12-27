Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1L0BZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:25:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40558 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab1L0BZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:25:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111226121207.GF8722@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
	<1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
	<20111220132314.GQ2866@opensource.wolfsonmicro.com>
	<CANKRQng8N3oS2o17HPUZeonXB3KLBK9oNQj-zd9+aUUvWcTo0A@mail.gmail.com>
	<20111222005816.GB27144@opensource.wolfsonmicro.com>
	<CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
	<20111222103946.GA4546@opensource.wolfsonmicro.com>
	<CANKRQng+H4NxaSLpZpYOCT-CdovxbToT-waz0JNMFT2AcD_gvA@mail.gmail.com>
	<20111226121207.GF8722@opensource.wolfsonmicro.com>
Date: Tue, 27 Dec 2011 10:25:25 +0900
Message-ID: <CANKRQnhJhpwhGywGz=r0tVF0k+eWb4vrGkdVD9NdzRFNo9PNtA@mail.gmail.com>
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
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

2011/12/26 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Dec 26, 2011 at 03:33:29PM +0900, Tomoya MORINAGA wrote:
>> 2011/12/22 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> >> Not sorted but queuing only.
>> >> In sound/voice control system, queuing is not rare, I think.
>> >> If necessary, though this method is very common, I can send the method
>> >> of the queue.
>
>> > No, please describe the problem you're trying to fix.
>
>> When CPU is heavy load, this buffer is useful.
>> The heavy load causes delaying receiving processing.
>> If there is no buffer, stream sound/voice can be broken.
>> If there is the buffer, it can prevent the broken sound.
>
> So you're just talking about standard underflows if the application
> can't keep up?
No. not only underflow but overflow.

> There's *no* reason for your driver to do anything about
> this, it's a really basic thing that affects all audio hardware.  Just
> write a driver for the hardware.
In case driver layer doesn't have the function,
which part works for the under/overflow ? Application ? or nothing ?

tomoya
