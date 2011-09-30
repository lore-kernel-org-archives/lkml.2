Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1I3Koz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:44:55 -0400
Received: from dan.rpsys.net ([93.97.175.187]:60472 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab1I3Koy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:44:54 -0400
Subject: Re: [PATCH] backlight: Rename corgibl_limit_intensity to
 genericbl_limit_intensity
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: axel.lin@gmail.com
Cc: Andrew Morton <akpm00@gmail.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 30 Sep 2011 11:44:42 +0100
In-Reply-To: <CAF+7xWkQ6SX9aUjBuaCgNVwKoiaBoV6gXfOYfw3MBf9B2c_wiA@mail.gmail.com>
References: <1316916753.5006.1.camel@phoenix>
	 <20110929130049.a3b56e19.akpm00@gmail.com> <1317327729.12332.121.camel@ted>
	 <CAF+7xWkQ6SX9aUjBuaCgNVwKoiaBoV6gXfOYfw3MBf9B2c_wiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317379490.12332.145.camel@ted>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 07:45 +0800, Axel Lin wrote:
> >> Why does corgibl_limit_intensity/genericbl_limit_intensity exist?
> >> Nothing in the tree references it?
> >
> > It sounds like someone has removed the sharpsl battery driver which did
> > use this. If this hook isn't used, low battery with high screen
> > backlight values will reset the device as the wiring isn't up to the
> > current draw.
> >
> It is removed by commit 13a542475d1c62a12c77abfa83a790245598fc61
> Author: Christoph Egger <siccegge@cs.fau.de>
> Date:   Sun Jul 4 23:24:52 2010 +0800
> 
>     [ARM] pxa: removing dead BACKLIGHT_CORGI
> 
>     BACKLIGHT_CORGI was later renamed to BACKLIGHT_GENERIC and has not been
>     used since then. As it's now safe to completely transition to LCD_CORGI
>     driver, which incorprates both the LCD and backlight device.
> 
>     Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
>     Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
> 
> So, should we remove corgibl_limit_intensity/genericbl_limit_intensity
> since now it is not being used?

Does that code workaround the hardware issue I mention? I suspect not.
It seems nobody cares about that at this point though...

Cheers,

Richard

