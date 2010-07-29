Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0G2T3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:29:42 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:38549 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab0G2T3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:29:41 -0400
Date: Thu, 29 Jul 2010 21:29:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729192938.GB7877@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <4C51473A.4000605@suse.cz> <20100729093946.GA6725@merkur.ravnborg.org> <4C515318.40706@suse.cz> <20100729073016.ba265b59.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729073016.ba265b59.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 07:30:16AM -0700, Randy Dunlap wrote:
> On Thu, 29 Jul 2010 12:08:24 +0200 Michal Marek wrote:
> 
> > On 29.7.2010 11:39, Sam Ravnborg wrote:
> > > I had in mind to deprecate randconfig in favour of allrandconfig
> > > to get more consitency in the names.
> > > But I failed to document this in the changelog.
> > > 
> > > I can submit the following as a real patch if you agree.
> > 
> > To me it seems like a change for the sake of change :), but if you like
> > to have the targets named all*config consistenly, I'm OK with it.
> 
> 
> Well, there are scripts that know the old name, so if it's just change
> for the sake of change, let's not.

I will respin the patches where I drop this change and keep "randconfig".
Thanks for input from both of you!

	Sam
