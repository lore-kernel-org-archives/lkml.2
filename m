Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0G2TsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102Ab0G2Trp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:47:45 -0400
Date: Thu, 29 Jul 2010 15:50:52 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729195052.GB20261@redhat.com>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com> <4C519899.9020206@suse.cz> <20100729151650.GA20261@redhat.com> <20100729193454.GC7877@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729193454.GC7877@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 09:34:55PM +0200, Sam Ravnborg wrote:
> If you have a simple command that give you a list of new
> symbols then this is easy to script as Michal also
> shows with the below example.
> 
> > > How about
> > > new=$(make listnewconfig)
> > > if test -n "$new"; then
> > >     echo "Please set the following options:" >&2
> > >     echo "$new" >&2
> > >     exit 1
> > > fi
> > > ? Wouldn't that be the same as nonint_oldconfig before?
> > what's the other use cases for listnewconfig (other than a incomplete
> > nonint_oldconfig)?
> 
> listnewconfig is for everyone that like to see a list of new
> config options - without touching the current configuration.
> 
> By limiting listnewconfig to do only one thing you actually
> create further uses than before.
> 
> This is not about how well it applies to the tailored
> use in redhat's current scripts.
*sigh* I think we have people able to handle such complex changes.

this is not what it's about. I don't care how it's called or if scripts
will need to be changed. What I want to know is if either:
a) we're reducing functionality of something in order to support more *real*
   use cases with the same code, making it more generic;
or
b) we're reducing functionality based in theorical use cases.

if it's (a), you get my ACK

-- 
Aristeu

