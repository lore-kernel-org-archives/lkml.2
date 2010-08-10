Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0HJMMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:12:25 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51681 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJMMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:12:21 -0400
Date: Tue, 10 Aug 2010 08:12:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@lynx
To: Jason Wessel <jason.wessel@windriver.com>
cc: Jon Masters <jonathan@jonmasters.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why can't i use gdb to dump module variables anymore?
In-Reply-To: <4C613F95.8020505@windriver.com>
Message-ID: <alpine.DEB.2.00.1008100807530.3885@lynx>
References: <alpine.DEB.2.00.1007080744180.7016@lynx> <7C33277E-D90E-4459-8580-59C5EFB2D66D@jonmasters.org> <alpine.DEB.2.00.1008091200520.3863@lynx> <4C613F95.8020505@windriver.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Aug 2010, Jason Wessel wrote:

> On 08/09/2010 11:06 AM, Robert P. J. Day wrote:
> > On Sun, 8 Aug 2010, Jon Masters wrote:
> >
> >
> >> On Jul 8, 2010, at 7:51 AM, Robert P. J. Day wrote:
> >>
> >>> (gdb) p rpjday_2
> >>> Cannot access memory at address 0xffffffffa007c0b4
> >>> (gdb) p rpjday_3
> >>> Cannot access memory at address 0xffffffffa007c0b8
> >>>
> >> Did you ever get a reply to this one? Were you trying to do this
> >> locally, by loading a kernel core or using kgdb?
> >>
> >
> >   never figured out what was happening here, used to work just
> > fine for simple gdb debugging of the kernel; nowadays (at least on
> > ubuntu), not so much.  anyway, i'm in bahstahn for linuxcon,
> > staying at the onyx hotel for first 3 days.  my girlfriend is
> > doing a bofs session:
> >
> > http://events.linuxfoundation.org/linuxcon2010/mckinnon
> >
> >   anyway, regarding gdb, this was based on a column i wrote last
> > year:
> >
> > http://www.linux.com/learn/linux-training/33991-the-kernel-newbie-corner-kernel-and-module-debugging-with-gdb
> >
> > where it worked just fine -- it's the technique described in LDD3.
> > but now, on ubuntu 10.04, weirdness.  i haven't looked at it
> > closely again for a while, but if you have any ideas, i'm open to
> > suggestions. maybe some odd security/selinux/??? setting?
> >
>
> I took a brief look at the instructions you had a the URL.  It
> seemed like something that should probably work ok unless that
> memory address is really not accessible via /proc/kcore.

  i've used that technique before as a simple way to examine kernel
data on a running system, and it always worked fine before.

> Depending on the age of the ubuntu system and if you have a serial
> port or not, kgdb is actually enabled in the kernel and you could
> certainly try the same test there.

  i can give that a shot later, certainly.

> It should also be possible to try out a gdb with kernel module
> awareness on the /proc/kcore.  If you want to try and debug it at
> some point perhaps we'll cross paths at LinuxCON.

  i haven't looked at this issue for a while, but i'd certainly like
to figure out why what used to work before has stopped working.  this
is something i like to show my beginner kernel programming students,
and it's moderately frustrating that i can't get it to work anymore.

  i'm sure it's something idiotic i'm doing.  and i'm around linuxcon
all week, so yes, let's bump into each other.

rday


-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Top-notch, inexpensive online Linux/OSS/kernel courses
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
