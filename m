Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0G2PRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 11:17:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0G2PRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 11:17:14 -0400
Date: Thu, 29 Jul 2010 16:17:11 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Introducing the LCD-Linux project
In-Reply-To: <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1007291616490.7618@casper.infradead.org>
References: <AANLkTikitTGpiE5Oe_P5a4f2OCOnlB9j_LVm5CQhQIno@mail.gmail.com> <20100722122111.4cf4ca2f@lxorguk.ukuu.org.uk> <AANLkTilKJx18oyc815DhKfPv-Yjdv8UmfJ4WTDxZxaab@mail.gmail.com> <AANLkTimnxkn5eLRHOAs6v_TJE0hM5=dQ3OWaiQP6tPJd@mail.gmail.com>
 <loom.20100724T155117-833@post.gmane.org> <AANLkTi=LAHhHEK3vbtwefroOrpoKpUs5B5=iu5_asMp6@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-256302951-1280416631=:7618"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-256302951-1280416631=:7618
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


> On Sat, Jul 24, 2010 at 16:43, Florian Tobias Schandinat
> <FlorianSchandinat@gmx.de> wrote:
> > Mattia Jona-Lasinio <mattia.jona <at> gmail.com> writes:
> >> Moreover I wanted something that COULD be used as a console but not
> >> necessarily, that is
> >> something that could run happily in the presence of a normal monitor
> >> as well. It seems to me, but I may be
> >> wrong, that through the standard console system only the current
> >> visible console is actually updated
> >> while other consoles are just "software" updated. An external LCD
> >> would therefore be updated
> >> only when you "switch" to it, so it would not be possible to use it to
> >> display diagnostics.
> >
> > True, that's a general problem one has when multiple framebuffers exist.
> > Therefore I'd be very happy if someone could come up with a general solution.
> 
> Fixing that was (one of the) goal of the linux-console project. James?

Yeap. That was one of the goals. Plus a bunch others.

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
--1985284609-256302951-1280416631=:7618--
