Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2CSQlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:41:35 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41378 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2CSQlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:41:32 -0400
Message-ID: <1332175190.32717.151.camel@groeck-laptop>
Subject: Re: [PATCH] gpio: add support for ITE IT87xx Super I/O GPIO.
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Linus Walleij <linus.walleij@linaro.org>
CC: Diego Elio =?ISO-8859-1?Q?Petten=F2?= <flameeyes@flameeyes.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Denis Turischev <denis@compulab.co.il>
Date: Mon, 19 Mar 2012 09:39:50 -0700
In-Reply-To: <CACRpkdYTPc9b0ys-rMJ6VJSxVX9uubq6r1QFk4bQN5rMiqQPMQ@mail.gmail.com>
References: <1331927293-17911-1-git-send-email-flameeyes@flameeyes.eu>
	 <20120317123151.AAF9A3E0952@localhost>
	 <1332010422.22775.76.camel@saladin.home.flameeyes.eu>
	 <CACRpkdb4PbZWm8vCaC0MO0a=K+0ZBDhmvoRrTtKXqEy-Jz-VWQ@mail.gmail.com>
	 <20120319005406.GA28497@ericsson.com>
	 <CACRpkdbZJR7NObUQCkjCEu3KedS5bfD4TuMGakL_N7BxKNUJnA@mail.gmail.com>
	 <20120319135636.GA30456@ericsson.com>
	 <CACRpkdYTPc9b0ys-rMJ6VJSxVX9uubq6r1QFk4bQN5rMiqQPMQ@mail.gmail.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 10:05 -0400, Linus Walleij wrote:
> On Mon, Mar 19, 2012 at 2:56 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > On Mon, Mar 19, 2012 at 04:26:44AM -0400, Linus Walleij wrote:
> 
> >> OK that is pinmuxing, if that is to be software-controlled the place to do
> >> it is in drivers/pinctrl. (Documentation/pinctrl.txt gives the backrgound.)
> (...)
> >>
> > Personally I would not dare touch those pins. If a pin is configured as UART pin
> > (or whatever), it is quite unlikely that it is exposed as GPIO pin. Worst case,
> > changing the configuration may result in broken hardware. Not sure what is supposed
> > to be gained by enabling the user to do that.
> 
> Define "user", pinctrl does not have userspace interfaces if that's
> what you mean.
> 
> If you mean "kernel programmer", these creatures seem to not respect what
> they should and shouldn't poke at ;-)
> 
> The usecase is typically if the hardware is used in two different systems
> where the ROM/bootcode/etc does not set up muxing correctly, or are setup
> in a sub-optimal way (e.g. working but consuming too much power) and the
> kernel needs to get involved. Unless you have any scenario like that, no
> need to worry about it.
> 
Ok, guess that makes sense.

Thanks,
Guenter


