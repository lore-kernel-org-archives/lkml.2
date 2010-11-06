Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0KFTXI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:23:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:45163 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab0KFTXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:23:07 -0400
Date: Sat, 6 Nov 2010 15:22:59 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101106192259.GB2935@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Elvis Dowson <elvis.dowson@mac.com>,
	Janakiram Sistla <janakiram.sistla@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
 <20101106181202.GA6927@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101106181202.GA6927@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 11:12:02AM -0700, Greg KH wrote:
> Are you willing to maintain the android kernel code in the mainline
> kernel tree?  If so, I will be glad to add it back in, but as no one was
> willing to do the work, it was removed.  It's as simple as that.

Note that whoever needs maintain the Android kernel code in mainline
needs to be working with both the Android kernel developers as well as
the upstream maintainers, in hopes of finding a way to find a path
which meets the requirements of both the android kernel developers and
the upstream kernel maintainers.

Otherwise, it's highly likely that no forward progress will get made,
and the code will get yanked from staging after 6-9 months of no
forward progress.

Given that the Android kernel developers have already spent upwards of
ten times the amount of engineering hours it would take forward port
their kernel patches to each upstream kernel version for the next
several years, finding a path that meets their requirements as well as
those of the upstream kernel maintainers may not be a trivial thing.

Also keep in mind that someone no less than Linus Torvalds has said
that sometimes forks are good, and that the _freedom_ to fork is
critical.  But if anyone feels that figuring out some way to make the
android kernel patches (a) upstreamable, and (b) compatible with
android's userspace is their itch to scratch, the other part of the
open source ethos is that they are certainly free to try.

	      				- Ted

P.S.  I speak for myself, and not for my employer.
