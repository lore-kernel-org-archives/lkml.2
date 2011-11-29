Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab1K2RFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:05:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55061 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab1K2RFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:05:22 -0500
Date: Tue, 29 Nov 2011 09:05:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
Message-ID: <20111129170514.GA4241@core.coreip.homeip.net>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
 <201111281753.45287.arnd@arndb.de>
 <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
 <201111291359.59103.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111291359.59103.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 01:59:58PM +0000, Arnd Bergmann wrote:
> On Tuesday 29 November 2011, MyungJoo Ham wrote:
> > For the next iteration, I'm considering the followings. It'd be much
> > appreciated if I could get some comments about those beforehand.
> >
> > 2. move the location from /drivers/misc to an independent location.
> > /drivers/switch? /drivers/multistate-switch? /drivers/msc?
> > /drivers/mswitch? ...
> 
> Moving out of drivers/misc is a good idea. I don't have a strong
> preference for any of the alternatives, but would probably pick
> drivers/mswitch. drivers/switch is too generic, since we have lots
> of things that are called a switch already, and drivers/multistate-switch
> is much longer than any of the other alternatives. "msc" in turn
> seems a bit too short and is not a well-established acronym yet.

It does not really limited to switches I think. Plug? Interconnect
(connector is already taken)? Link?

Thanks.

-- 
Dmitry
