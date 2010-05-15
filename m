Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0EOOrX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 10:47:23 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42045 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab0EOOrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 10:47:22 -0400
Date: Sat, 15 May 2010 15:46:39 +0100
From: Russell King <rmk+pcmcia@arm.linux.org.uk>
To: linux-pcmcia@lists.infradead.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, Vincent Sanders <vince@kyllikki.org>
Subject: Re: [PATCH 5/5] pcmcia: disable pcmcia ioctl for !ARM, prepare for
	removal
Message-ID: <20100515144639.GA10987@flint.arm.linux.org.uk>
Mail-Followup-To: linux-pcmcia@lists.infradead.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-kernel@vger.kernel.org, Vincent Sanders <vince@kyllikki.org>
References: <20100303075944.GA23354@comet.dominikbrodowski.net> <1267603248-23866-5-git-send-email-linux@dominikbrodowski.net> <20100515142409.GB18960@flint.arm.linux.org.uk> <20100515143705.GA10617@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100515143705.GA10617@isilmar-3.linta.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 15, 2010 at 04:37:05PM +0200, Dominik Brodowski wrote:
> Russell,
> 
> On Sat, May 15, 2010 at 03:24:10PM +0100, Russell King wrote:
> > On Wed, Mar 03, 2010 at 09:00:48AM +0100, Dominik Brodowski wrote:
> > > Furthermore, the last legitimate use of the ioctl to be reported
> > > relates to the ARM architecture in 2008.[1] Attempts to resolve
> > > this issue turned out unsuccessful so far.[2] Other usages have only
> > > been reported as hear-say. If there are any legitiate and necessary
> > > use-cases remaining, please speak out before the end of the grace
> > > period until 2.6.3{5,6}(-rc1).
> > 
> > What's the point of speaking out?  You don't take any notice of people
> > who do, and you continue your crusade of wanting to remove it.  Please,
> > stop giving the impression that you give a damn of what people say about
> > the ioctl interface.
> 
> The _only_ person who really has spoken out is you. All my requests to
> actually see source code or actual use cases (e.g. which parts of the ioctl
> do actually get called) did not lead to _anything_.

See the source code?  You clearly haven't been reading what I've been
saying to you on the subject if you think I can produce source code.
I've already explained this to you several times, but it seems to be
constantly ignored.

Don't you think that if I had the source code, then there wouldn't be
this problem in the first place - it would be possible to fix the
offending programs myself.

There's maybe one person who _may_ still have the source code - Vince
Sanders - and despite asking many times for it, I've had zero progress
on it.

Maybe I should have walked away with a copy of the source myself - but
it wasn't practical to take a copy of several GB of build system across
a 512kbps ADSL connection as it was back then.

I'm sorry that you find it soo hard to accept what I've been saying over
the last few years on this, but it seems that you only have one interest
and that's to remove the ioctl no matter what anyone says.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
