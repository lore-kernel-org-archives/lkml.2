Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0GaGPn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 02:15:43 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52873 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754536Ab0GaGPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 02:15:42 -0400
Date: Sat, 31 Jul 2010 08:15:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        linux-kernel@vger.kernel.org
Subject: Re: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100731061536.GA4945@ucw.cz>
References: <20100722225212.GA19361@darkside.kls.lan>
 <20100723143219.GA2426@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100723143219.GA2426@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-07-23 10:32:19, John W. Linville wrote:
> On Fri, Jul 23, 2010 at 12:52:12AM +0200, Mario 'BitKoenig' Holbe wrote:
> > Hello,
> > 
> > the b43 wireless driver inhibits access to /dev/hwrng while the wireless
> > network interface is down. When the interface is up, /dev/hwrng is
> > accessible:
> 
> <snip>
> 
> > I have no idea whether this issue belongs to the b43 driver or to the
> > rng core.
> 
> The hwrng driver is provided by the b43 hardware, which is shutdown
> when the network interface is down.  I'm not sure how one could expect
> this to work.

Well... either don't provide hwrng interface, or power up enough of
b43 hardware when user opens /dev/hwrng...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
