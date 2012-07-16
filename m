Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab2GPRmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:42:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42729 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab2GPRmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:42:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: 3.5-rcX: wakeup after s2ram doesn't work after a longer sleep time
Date: Mon, 16 Jul 2012 19:47:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <500319E9.8010001@gmx.de> <201207152221.48232.rjw@sisk.pl> <50041C1E.8070203@gmx.de>
In-Reply-To: <50041C1E.8070203@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201207161947.55896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012, Toralf Förster wrote:
> On 07/15/2012 10:21 PM, Rafael J. Wysocki wrote:
> > On Sunday, July 15, 2012, Toralf Förster wrote:
> >> My ThinkPad T400 (Gentoo Linux booted from an external USB drive) does
> >> not wake up after s2ram, if the  sleep time was longer than about 1 hour.
> >> I'm unsure whether this started after 3.5-rc5, at least with -rc7 I
> >> observed this now several times. Unfortunately it is not 100% reproduceable.
> >>
> >> 3.4.x works flawlessly.
> >>
> >> Any idea whether a particular commit could be the culprit ? (Bisecting
> >> such an issue is a night mare)
> > 
> > Please check
> > 
> > commit 5baefd6d84163443215f4a99f6a20f054ef11236
> > Author: John Stultz <johnstul@us.ibm.com>
> > Date:   Tue Jul 10 18:43:25 2012 -0400
> > 
> >     hrtimer: Update hrtimer base offsets each hrtimer_interrupt
> > 
> > Thanks,
> > Rafael
> > 
> 
> No,
> reverting doesn#t help.
> 
> I can r2ram several times in a row w/o problems, if the sleep time as
> within seconds.
> After 20 min however the system doesn't came back (the internal hard
> disk spins up, but the sleep-state-led is still on).

Well, so this is a different issue definitely.

Thanks,
Rafael
