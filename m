Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab0E0UTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:19:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49735 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab0E0UTp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:19:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
Date: Thu, 27 May 2010 22:21:08 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
       =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com> <20100526223101.3f2dd7dd.rdunlap@xenotime.net> <AANLkTik2ggnZYixbVPVDgQjUIsJVW-UQyItmR-soghc0@mail.gmail.com>
In-Reply-To: <AANLkTik2ggnZYixbVPVDgQjUIsJVW-UQyItmR-soghc0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005272221.08985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010, Geert Uytterhoeven wrote:
> On Thu, May 27, 2010 at 07:31, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Thu, 27 May 2010 12:31:23 +0800 Américo Wang wrote:
> >> On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
> >> >On Thu, May 27, 2010 at 5:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
> >> >>> Hello,
> >> >>>
> >> >>> I am trying to build 32 bit kernel image on 64-bit machine but after
> >> >>> 'make menuconfig' it automatically switches 32-bit to 64-bit.
> >> >>
> >> >> Try 'linux32 make menuconfig' and 'linux32 make'.
> >> >>
> >> >
> >> >Yes, this works :-)
> >>
> >>
> >> I think 'make ARCH=i386 menuconfig' also works.
> >
> > Yes, that's what I use.  I wasn't familiar with the "linux32 make ..." usage.
> 
> Doesn't the linux32 trick run the (possibly slower due to x86 register pressure)
> 32-bit compiler instead of running the 64-bit compiler in -m32 mode?

You're probably right, but I haven't noticed a difference yet. :-)

Rafael
