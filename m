Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab1AIHPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 02:15:25 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:53389 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750835Ab1AIHPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 02:15:24 -0500
Date: Sun, 9 Jan 2011 08:14:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pma@sysgo.com>, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: suspicious code in linux/arch/arm/common/sa1111.c
Message-ID: <20110109071459.GA1488@ucw.cz>
References: <20101116090705.GA29337@pma.sysgo.com>
 <AANLkTin6QAr7=7-59aKzunh6nQGhCKPJ11OspBtC4NHB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin6QAr7=7-59aKzunh6nQGhCKPJ11OspBtC4NHB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-11-16 17:09:59, Eric Miao wrote:
> On Tue, Nov 16, 2010 at 5:07 PM, Pavel Machek <pma@sysgo.com> wrote:
> > Hi!
> >
> > Is this good idea?
> >
> > Signed-off-by: Pavel Machek <pma@sysgo.com>
> 
> Yep, obviously was a typo.

Can you apply the patch? Or should I re--generate one with better changelog?

> > diff -ur linux.ofic//arch/arm/common/sa1111.c linux/arch/arm/common/sa1111.c
> > --- linux.ofic//arch/arm/common/sa1111.c        2010-10-17 20:31:13.000000000 +0200
> > +++ linux/arch/arm/common/sa1111.c      2010-11-05 10:44:17.000000000 +0100
> > @@ -282,7 +312,7 @@
> >        for (i = 0; i < 8; i++) {
> >                sa1111_writel(ip0 ^ mask, mapbase + SA1111_INTPOL0);
> >                sa1111_writel(ip0, mapbase + SA1111_INTPOL0);
> > -               if (sa1111_readl(mapbase + SA1111_INTSTATCLR1) & mask)
> > +               if (sa1111_readl(mapbase + SA1111_INTSTATCLR0) & mask)
> >                        break;
> >        }
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
