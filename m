Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab0E1W1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:27:41 -0400
Received: from leo.clearchain.com ([199.73.29.74]:33164 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0E1W1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:27:40 -0400
Date: Sat, 29 May 2010 08:27:17 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Bastien Nocera <hadess@hadess.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.35-rc0
Message-ID: <20100528222717.GB28502@barra>
References: <20100520165243.GA20861@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org>
 <AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com>
 <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
 <AANLkTinPt49coLNjPqJSSxDP8zTmnjbKuIP1NuQFvwL-@mail.gmail.com>
 <20100528061957.GA19624@quokka.bne.redhat.com>
 <alpine.LFD.2.00.1005280724550.11382@i5.linux-foundation.org>
 <1275058885.31676.7166.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275058885.31676.7166.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Sat, 29 May 2010 07:57:21 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 04:01:25PM +0100, Bastien Nocera wrote:
> > That Dell machine got a lot of bad reviews for its horribe touchpad, and I 
> > used to not understand why people disliked the touchpad so much - it 
> > didn't feel horrible to me. But now I wonder if Windows has the same 
> > logic, and reviewers - like me - hadn't realized to enable the tap 
> > feature.
> 
> On windows, it's basically as horrible as you suggested if you don't
> install the elantech drivers.
> 
> For the default GNOME configuration, we could certainly switch it again,
> but we would break people with older laptops.
> 
> Seeing as we already know if there's physical buttons, we would just
> need to know whether the physical buttons are embedded in the touchpad
> like on yours. Then we could make an informed decision about the
> defaults.
> 
> I'm sure that Peter would love the challenge of exporting that to the
> desktops :)

Yeah. exciting...
At the moment we rely on udev to tag the device based on the the dmi product
name. Unless I've missed something else, this is the _only_ thing we can go
on. The touchpad hardware itself looks sane and even the driver doesn't know
that this touchpad is crap, it simply applies an option to disable part of
the touchpad for movements because that's what our xorg.conf.d snippets say.
I'd love to have an EVIOISTHISDEVICEONCRACK ioctl, but for now we have to
work around it.

For clients, well, I just don't know yet how to export this.

Cheers,
  Peter
