Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab1E3B7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:59:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38218 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab1E3B7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:59:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.0-rc1
Date: Mon, 30 May 2011 03:59:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
In-Reply-To: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300359.28515.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 30, 2011, Linus Torvalds wrote:
> Yay! Let the bikeshed painting discussions about version numbering
> begin (or at least re-start).
> 
> I decided to just bite the bullet, and call the next version 3.0. It
> will get released close enough to the 20-year mark, which is excuse
> enough for me, although honestly, the real reason is just that I can
> no longe rcomfortably count as high as 40.
> 
> The whole renumbering was discussed at last years Kernel Summit, and
> there was a plan to take it up this year too. But let's face it -
> what's the point of being in charge if you can't pick the bike shed
> color without holding a referendum on it? So I'm just going all
> alpha-male, and just renumbering it. You'll like it.
> 
> Now, my alpha-maleness sadly does not actually extend to all the
> scripts and Makefile rules, so the kernel is fighting back, and is
> calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> into submission, and get scripts etc cleaned up, and the final release
> should be just "3.0". The -stable team can use the third number for
> their versioning.
> 
> So what are the big changes?
> 
> NOTHING. Absolutely nothing. Sure, we have the usual two thirds driver
> changes, and a lot of random fixes, but the point is that 3.0 is
> *just* about renumbering, we are very much *not* doing a KDE-4 or a
> Gnome-3 here. No breakage, no special scary new features, nothing at
> all like that. We've been doing time-based releases for many years
> now, this is in no way about features. If you want an excuse for the
> renumbering, you really should look at the time-based one ("20 years")
> instead.
> 
> So no ABI changes, no API changes,

Well, actually there is one. ;-)  The shutdown/suspend/resume callbacks have
been removed from struct sysdev_class and struct sysdev_driver.

Not that this is important to anyone except for the 10 people or so who care,
but still. :-)

Thanks for the numbering change,
Rafael
