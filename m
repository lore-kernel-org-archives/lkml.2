Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab2GMW0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:26:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2GMW0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:26:33 -0400
Date: Fri, 13 Jul 2012 18:26:17 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Message-ID: <20120713222616.GA2822@zod.bos.redhat.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <20120713210240.GG1707@redhat.com>
 <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 02:17:30PM -0700, Linus Torvalds wrote:
> On Fri, Jul 13, 2012 at 2:02 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > As long as you don't mind these being added after the fact, I suppose
> > it would be workable.  The reason I say that is sometimes, it even catches *us*
> > by surprise.  We recently found out our virtualisation guys started
> > using sch_htb for example, and we inadvertantly broke it when we moved
> > its module to a 'not always installed' kernel subpackage. (and before that, 9PFS..)
> >
> > People don't tell us anything, but somehow expect things to keep working.
> 
> I think even a "educated guess" config file is better than what we have now.
> 
> The *two* requirements (and they're really the same theme) I
> personally think we should have for this are
> 
>  -  I think every single "select" for these things should come with a
> comment about what it is about and why the distro needs it (to show
> there was some thought involved and not just a blind "took it from the
> distro config")
> 
>  - It should be about *minimal* settings. I'd rather have too few
> things and the occasional complaint about "oh, it didn't work because
> it missed XYZ" than have it grow to contain all the options just
> because somebody decided to just add random things until things
> worked.

I'd agree that should be the goal.  It seems like something worth at
least trying to get to.  Even if we don't wind up merging them into the
kernel, it will at least lead to a better documented distro config for
every one that tries it.

josh
