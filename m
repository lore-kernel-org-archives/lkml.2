Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0KIN1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:27:16 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42311 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0KIN1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :organization:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=OvoIZv6Yfs5ZQ0EQtNa15tB95bCltyDsOLiKaRUcDojF2reQgniPbO5VBkI4xH31m9
         aMCFdAqNZ6YXnjGmUp3i2vW78eE4wiN7+7g3h+0dZSic1zPudqG5Kjbe2/G5T9ogPhGa
         kNXlr/FN/A1ocABAYttnUj9jcktlaACI21eQI=
From: Florian Fainelli <florian@openwrt.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Subject: Re: Forked android kernel development from linux kernel mainline
Date: Tue, 9 Nov 2010 14:27:09 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-server; KDE/4.5.1; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <20101107155757.GA13736@kroah.com> <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
In-Reply-To: <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091427.09050.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud,

On Sunday 07 November 2010 22:44:48 Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Nov 7, 2010 at 10:57 AM, Greg KH <greg@kroah.com> wrote:
> > [...]
> 
> Just a small comment to say that Android is not the only one (but
> certainly the most visible, and thus easiest to bash on) not making
> effort to get their stuff in mainline. OpenWRT people are also
> maintaining their fork of the kernel, without even using git, and not
> contributing much to mainline (I'm certainly mistaken on that last
> comment).

You are a bit rude and mistaking at the same time. We did contribute back TI 
AR7, Mikrotik RB532, RDC R-321x, IXP4xx to name a few and a lot of various 
patches on different related projects.

So I do agree the situation is not the best because we still maintain too many 
patches in the OpenWrt repository, especially since the added value of OpenWrt 
do not only resides in the kernel patches for a specific target.

Please understand that we are just human beings and right now, ar71xx is 
becoming more and more present on the wireless routers market, that's why 
developpers (Imre and Gabor) are being kept busy making this target work fine 
on all of the routers out there (and it's not just about 1 or 2 models, we are 
talking about nearly 50, all of these with different hardware integration, thus 
challenges).

The fact that we are using subversion is purely gratuitous, remember this is 
just a tool after all. The flat structure that we have, and the per-kernel 
version patches still makes it easy for people to pick whatever they need from 
our tree. Certainly this is not ideal, but no major stopper.

> 
> I'm still stuck to use their 2.6.32 to use my AR71xx-based (MIPS)
> boards, just this part is +15kloc.

2.6.36 support for ar71xx is out there since Oct 8th.
--
Florian
