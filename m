Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0KJUjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:39:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab0KJUjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:39:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Wed, 10 Nov 2010 21:38:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Anca Emanuel <anca.emanuel@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <20101107000348.GF2935@thunk.org> <20101110135458.GB1553@ucw.cz>
In-Reply-To: <20101110135458.GB1553@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011102138.22213.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 10, 2010, Pavel Machek wrote:
> On Sat 2010-11-06 20:03:48, Ted Ts'o wrote:
> > On Sat, Nov 06, 2010 at 04:52:26PM -0700, david@lang.hm wrote:
> > > also, none of these other patches resulted in device drivers
> > > developed for a distro being incompatible with mainline.
> > 
> > What, people can't delete a couple of single lines of code before
> > submitting the device driver upstream to mainline?  Here's the world's
> > tiniest violin playing, "my heart bleeds for you"....
> 
> Deleting couple single liners is not a problem. Cleaning up 100KLoC
> patch for mainline *is* a problem.
> 
> I know, I tried to do that work. Even getting it to staging quality
> was hard, and it was recently dropped due to security holes.
> 
> Unfortunately google uses wakelocks as an excuse for not cleaning up
> stuff... "because readding those few lines would be too hard".

Actually, this isn't a good excuse any more as of 2.6.37-rc1.  You can
basically replace wakelocks with wakeup sources and go ahead.

Thanks,
Rafael
