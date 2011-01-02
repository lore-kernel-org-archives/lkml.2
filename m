Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1ABJAE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:00:04 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51075 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751004Ab1ABJAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:00:02 -0500
Date: Sun, 2 Jan 2011 10:00:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VERY slow scrolling on radeon graphics card: debugging a
	timing issue?
Message-ID: <20110102090001.GB32469@atrey.karlin.mff.cuni.cz>
References: <4D0FC36D.9010304@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0FC36D.9010304@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The thing is: that same scrolling becomes much faster
> when I "do something" else while it scrolls up.  First
> I noticed this when I wanted to switch to another vt
> while it were scrolling -- I held down Ctrl key on my
> keyboard, and out of the sudden the scroll speed up
> dramatically.
> 
> It turned out I can speed the thing to about 10 times
> by generating some load: hit and hold a key on the
> keyboard (generates interrupts?), run kernel compile
> in the background (generates disk interrupts?), move
> mouse...

Try "irqpoll"?

Will cpu load speed it up, too? (Like yes > /dev/null)?

> Any hints on where to go from there are apprecated.
> 
> The hardware is an AMD780g-based motherboard with
> and Athlon CPU, I've seen the same behavour from
> many other similar boards.  Kernels - all up to
> the current 2.6.36.2, sine the old days when kms
> for radeon first appeared in staging.

Watch /proc/interrupts to see if radeon uses them and if they appear
to work?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
