Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab0DKWYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 18:24:42 -0400
Received: from www.tglx.de ([62.245.132.106]:35344 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0DKWYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 18:24:41 -0400
Date: Mon, 12 Apr 2010 00:24:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: LOCALVERSION_AUTO considered harmful
In-Reply-To: <20100411201426.GC25294@elf.ucw.cz>
Message-ID: <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200> <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com> <20100411201426.GC25294@elf.ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2080386426-1271024652=:18009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2080386426-1271024652=:18009
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 11 Apr 2010, Pavel Machek wrote:

> On Sun 2010-04-11 20:58:58, Geert Uytterhoeven wrote:
> > On Mon, Apr 12, 2010 at 20:51, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > > On Sun, Apr 11, 2010 at 06:47:01PM +0200, Pavel Machek wrote:
> > >> @@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
> > >>         appended after any matching localversion* files, and after the value
> > >>         set in CONFIG_LOCALVERSION.
> > >>
> > >> +       Unfortunately, such finegrained versioning will mean that you will
> > >> +       not be able to use modules for development; even "make modules"
> > >> +       will change module versions, making recompiled modules impossible
> > >> +       to insert into old kernel.
> > >
> > > That's conditional BS.
> > > Turn off CONFIG_MODVERSIONS already.
> > 
> > Yeah, I disabled it ages ago. Even then (before git, probably even
> > before bitkeeper)
> > I had hard times inserting modules...
> 
> I _had_ it off
> 
>  # CONFIG_MODVERSIONS is not set
> 
> It seems some checking survives CONFIG_MODVERSIONS unset and that
> checking is strict enough to refuse module load after one "make
> modules" with LOCALVERSION_AUTO on...

So instead of fixing the CONFIG_MODVERSIONS=n case you go the easy way
of killing LOCALVERSION_AUTO ? Brilliant.

Thanks,

	tglx
--8323328-2080386426-1271024652=:18009--
