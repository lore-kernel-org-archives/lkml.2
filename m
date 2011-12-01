Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1LAEqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 23:46:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab1LAEqO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 23:46:14 -0500
MIME-Version: 1.0
In-Reply-To: <20111201095633.700e2923@notabene.brown>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
	<20111130135847.68a6e4c6@notabene.brown>
	<CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com>
	<20111201095633.700e2923@notabene.brown>
Date: Thu, 1 Dec 2011 13:46:12 +0900
Message-ID: <CAJ0PZbQxxaE6fGnKpOwSJpGpAF=SMjBnF8UZWoPVK1h3vKkqJA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 1, 2011 at 7:56 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 30 Nov 2011 15:40:48 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
> wrote:
>
>> I'm focusing on an external connector or port that each physical port
>> may inhabit multiple cables at a time although it should support a
>> port that may inhabit a single cable only at a time. However, the
>> class could be used for other general "multistate mux" that connects
>> different device drivers.
>
> Hi,
>  maybe I'm just slow, but I'm having a lot of trouble imagining a single port
>  that could have multiple cables plugged in at the same time.  And this
>  blockage is stopping me from reflecting usefully on your other points.
>
>  Are you able to show me a picture or a diagram or something so I can
>  visualise what you are talking about?
>  To me: once you plug one cable into a port, it is full and there is no room
>  for any more cables.

Hello,

I can't take/send picture at work, so, I'll write some examples.

1. Dock with multiple ports as Mark suggested.
2. a 30-pin cable with multiple cable sockets (basically, this is a
light-weight dock, too). A cable that connects to multiple other
devics from a computer (including any ARM midgets and full PCs). Plus,
there can be multiple different types of such cables for a single
model of port. For example, in Samsung Galaxy Tab series, there is a
30-pin port, which can be connected to Serial(UART), Dedicated
charger, USB (either as a host or client), Audio I/O, HDMI, Video I/O,
and others. And the cable does not need to be 1-to-1 (Tab-to-USB,
Tab-to-HDMI). There are cables that may connect Tab-to-USB-and-HDMI or
Tab-to-Charger-and-A/V. In fact, among these 30 pins, there are
independent pins for HDMI, pins for Audio, pins for charging, pins for
USB, and others sharing ground/power pins, and a "multi-socket" 30-pin
cable may simply open them up to other "standard" cables.

Cheers!
MyungJoo


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
