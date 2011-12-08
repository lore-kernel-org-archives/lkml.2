Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1LHAAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:00:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab1LHAAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:00:06 -0500
Date: Wed, 7 Dec 2011 16:00:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Denis Kuzmenko <linux@solonet.org.ua>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] leds: driver for ab5500 high voltage leds
Message-Id: <20111207160002.8b52df42.akpm@linux-foundation.org>
In-Reply-To: <4EDFAA0A.7040607@solonet.org.ua>
References: <1322834182-26168-1-git-send-email-linus.walleij@stericsson.com>
	<4EDAA785.40503@solonet.org.ua>
	<CACRpkdaos1pLNDsnWe3xqaWtcAFDFy2yw+xjRi0++A=41SZvmw@mail.gmail.com>
	<4EDFAA0A.7040607@solonet.org.ua>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Dec 2011 20:01:46 +0200
Denis Kuzmenko <linux@solonet.org.ua> wrote:

> > The three channels are indeed high-voltage LEDs, they supply
> > up to 20V from a supply voltage of some standard mobile handset
> > battery at say 3.8 V or so. But there is no register to control the
> > voltage or anything like that.
> > 
> > My naive understanding is that you set the current limit and then
> > the HV transformer (I guess this is a buck converter of some kind)
> > will raise the voltage level until it either (A) cannot raise it any more
> > at c:a 20V or (b) the current limit is reached.
> > 
> > I suspect this is because for LEDs of this type you get a
> > specified current but the voltage just has to be "high enough"
> > to break through some diode barrier threshold or so. After
> > that intensity is controlled by limiting the current.
> > 
> > Does this suffice as explanation...?
> > 
> > Yours,
> > Linus Walleij
> 
> Yeah, It does, thank you.
> Does it worth to make additional comment in code to avoid further questions?

Yes, I think that the fact that a reviewer asked a question such as
this is a reliable sign that subsequent readers will be wondering the
same thing, so it is an "oops it needs a comment" signal.

I won't do anything with this patch yet - I'm waiting to see if Mark
stops being surprised ;)

