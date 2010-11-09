Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab0KINvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:51:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37000 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0KINvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:51:48 -0500
Date: Tue, 9 Nov 2010 13:51:29 +0000
From: Wolfgang Spraul <wolfgang@sharism.cc>
To: OpenWrt Development List <openwrt-devel@lists.openwrt.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Greg KH <greg@kroah.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Anca Emanuel <anca.emanuel@gmail.com>
Subject: Re: [OpenWrt-Devel] Forked android kernel development from linux
 kernel mainline
Message-ID: <20101109135129.GE14380@asus.wolf>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
 <20101107155757.GA13736@kroah.com>
 <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
 <201011091427.09050.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011091427.09050.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian and Greg,

> > Just a small comment to say that Android is not the only one (but
> > certainly the most visible, and thus easiest to bash on) not making
> > effort to get their stuff in mainline. OpenWRT people are also
> > maintaining their fork of the kernel, without even using git, and not
> > contributing much to mainline (I'm certainly mistaken on that last
> > comment).
> 
> You are a bit rude and mistaking at the same time. We did contribute back TI 
> AR7, Mikrotik RB532, RDC R-321x, IXP4xx to name a few and a lot of various 
> patches on different related projects.

I'm speaking as a bystander here, but Lars-Peter Clausen took an enormous
effort to get an entire new SoC, Ingenic's XBurst 4740, into mainline
Linux, using the OpenWrt patch system as his development/staging area.
A lot of that work was merged mainline in 2.6.36, some more is coming.

I think the mainline quality standards are high (nothing wrong with that),
so it's not easy to get stuff up to that level. And there is not exactly
much of a pull force either, if I may say so.

I have worked on numerous projects, platforms and build systems over
the years. The OpenWrt people and tools are some of the most upstream
oriented and best ways to get upstream I have seen.

The next big thing I will try to lend a helping hand to will be the
kernel.org inclusion of the Milkymist SoC.
A fairly clean and constantly re-based kernel is here
https://github.com/tmatsuya/linux-2.6
Linux 2.6.36+ is already booting, now it 'only' needs to go mainline ;-)
http://lists.milkymist.org/pipermail/devel-milkymist.org/2010-October/000979.html

Anybody mainline care to pull directly? That would be awesome. Otherwise
my next best bet would be to go to OpenWrt first, hack it into SVN
patches, then go from there. At least OpenWrt cares a lot to produce
buildable and bootable images at any time, that's an excellent way to
go for bigger and better things.

>From the perspective of someone looking from mainline, I can understand
the frustration over not seeing a git repo that one can pull from at
any time. But from the outside it looks a bit different. Patches are
sometimes forced to live outside mainline for a long long time, years.
And in those years the way OpenWrt is dealing with patches is still a
very effective system to avoid bitrot.

my 2c,
Wolfgang
