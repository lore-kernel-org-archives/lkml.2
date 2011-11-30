Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab1K3XRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 18:17:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59690 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621Ab1K3XRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 18:17:44 -0500
Date: Wed, 30 Nov 2011 23:17:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111130231740.GA25340@opensource.wolfsonmicro.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com> <201111251402.28016.arnd@arndb.de> <CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com> <201111281753.45287.arnd@arndb.de> <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com> <20111130135847.68a6e4c6@notabene.brown> <CAJ0PZbRpoz+uK4QUAO4RG5bhsSpNvm5U-ROtbduXhnFTLMZ1VQ@mail.gmail.com> <20111201095633.700e2923@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201095633.700e2923@notabene.brown>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 09:56:33AM +1100, NeilBrown wrote:
> On Wed, 30 Nov 2011 15:40:48 +0900 MyungJoo Ham <myungjoo.ham@gmail.com>
> wrote:

> > I'm focusing on an external connector or port that each physical port
> > may inhabit multiple cables at a time although it should support a
> > port that may inhabit a single cable only at a time. However, the
> > class could be used for other general "multistate mux" that connects
> > different device drivers.

>  maybe I'm just slow, but I'm having a lot of trouble imagining a single port
>  that could have multiple cables plugged in at the same time.  And this
>  blockage is stopping me from reflecting usefully on your other points.

>  Are you able to show me a picture or a diagram or something so I can
>  visualise what you are talking about?
>  To me: once you plug one cable into a port, it is full and there is no room
>  for any more cables.

One obvious example is the sort of big multi-way docking connector that
many mobile devices have (iPod and friends being one of the most
common).  These are essentially the same as docking station connections
on a laptop in terms of what they bring out - a variety of audio, video
and communication connections - which may go to a docking station or
some kind of breakout or adaptor cable and may have sub-ports hanging
off them (eg, it's common for tablets to have docking stations with HDMI
and audio sockets on them).

There are also lower pin count equivalents like the multiplexed "USB"
sockets on some phones which can also carry other functions with
adaptors, and even something like a headset is really a microphone and
headphones on a single jack.
