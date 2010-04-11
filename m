Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0DKUOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 16:14:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:37984 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752229Ab0DKUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 16:14:09 -0400
Date: Sun, 11 Apr 2010 22:14:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: LOCALVERSION_AUTO considered harmful
Message-ID: <20100411201426.GC25294@elf.ucw.cz>
References: <20100411164701.GA7558@elf.ucw.cz>
 <20100412185136.GA13171@x200>
 <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-04-11 20:58:58, Geert Uytterhoeven wrote:
> On Mon, Apr 12, 2010 at 20:51, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> > On Sun, Apr 11, 2010 at 06:47:01PM +0200, Pavel Machek wrote:
> >> @@ -99,6 +98,11 @@ config LOCALVERSION_AUTO
> >>         appended after any matching localversion* files, and after the value
> >>         set in CONFIG_LOCALVERSION.
> >>
> >> +       Unfortunately, such finegrained versioning will mean that you will
> >> +       not be able to use modules for development; even "make modules"
> >> +       will change module versions, making recompiled modules impossible
> >> +       to insert into old kernel.
> >
> > That's conditional BS.
> > Turn off CONFIG_MODVERSIONS already.
> 
> Yeah, I disabled it ages ago. Even then (before git, probably even
> before bitkeeper)
> I had hard times inserting modules...

I _had_ it off

 # CONFIG_MODVERSIONS is not set

It seems some checking survives CONFIG_MODVERSIONS unset and that
checking is strict enough to refuse module load after one "make
modules" with LOCALVERSION_AUTO on...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
