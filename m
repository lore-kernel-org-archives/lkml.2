Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab2LMRIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:08:50 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59267 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2LMRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:08:49 -0500
X-Originating-IP: 108.223.40.66
Date: Thu, 13 Dec 2012 09:08:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: anish singh <anish198519851985@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
Message-ID: <20121213170845.GA11145@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
 <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
 <20121207145955.GA28704@roeck-us.net>
 <20121207164906.08b65046@pyramind.ukuu.org.uk>
 <CACRpkdY2qht8Yxs2gzjHoxxqcqOP_v=-73OBmNfyO0qr1n+7MQ@mail.gmail.com>
 <20121210184819.GA15484@roeck-us.net>
 <CAK7N6vq8+H=Y1hD0vMEEiY6CtGkZivnmDKiwiuG12s9kf7y5qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7N6vq8+H=Y1hD0vMEEiY6CtGkZivnmDKiwiuG12s9kf7y5qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 11:37:35AM -0800, anish singh wrote:
> On Mon, Dec 10, 2012 at 10:48 AM, Guenter Roeck
> <groeck-dsl@sbcglobal.net> wrote:
> > On Mon, Dec 10, 2012 at 11:04:09AM +0100, Linus Walleij wrote:
> >> On Fri, Dec 7, 2012 at 5:49 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >>
> >> >> I could imagine declaring the activity request buttons to be "input", but for
> >> >> presence detects it is a bit far fetched and would add too much complexity.
> >> >
> >> > Android tries to address this with its switch class driver, but I'm not
> >> > sure its actually got anything over making them input devices.
> >>
> >> This has actually been merged into the kernel proper as drivers/extcon.
> >>
> >> So another poke on Günther if this fulfills the needs?
> >>
> > I'll look into it. Currently I am hampered by a cold which seems to mug my
> > brain, and technically by the need to backport extcon to 3.0 (if that is even
> > possible) since our chip vendor does not yet support a more recent kernel.
> It is very much possible.I have already tried that and it works.

Confirmed.

Looks like this is going to work for me, so I won't need the gpio patch. Please
ignore it.

Thanks,
Guenter
