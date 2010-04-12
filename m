Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab0DLNOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 09:14:23 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45824 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750888Ab0DLNOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 09:14:22 -0400
Date: Mon, 12 Apr 2010 15:14:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: LOCALVERSION_AUTO considered harmful
Message-ID: <20100412131405.GB22773@ucw.cz>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200> <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com> <20100411201426.GC25294@elf.ucw.cz> <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > That's conditional BS.
> > > > Turn off CONFIG_MODVERSIONS already.
> > > 
> > > Yeah, I disabled it ages ago. Even then (before git, probably even
> > > before bitkeeper)
> > > I had hard times inserting modules...
> > 
> > I _had_ it off
> > 
> >  # CONFIG_MODVERSIONS is not set
> > 
> > It seems some checking survives CONFIG_MODVERSIONS unset and that
> > checking is strict enough to refuse module load after one "make
> > modules" with LOCALVERSION_AUTO on...
> 
> So instead of fixing the CONFIG_MODVERSIONS=n case you go the easy way
> of killing LOCALVERSION_AUTO ? Brilliant.

In previous discussion, I was told that there's no bug to fix, that
everything works as intended.

I believe current behaiour is stupid, and I'd prefer *some* fix.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
