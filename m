Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0KKAlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:41:09 -0500
Received: from www.tglx.de ([62.245.132.106]:39577 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab0KKAlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:41:07 -0500
Date: Thu, 11 Nov 2010 01:40:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: Greg KH <greg@kroah.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
In-Reply-To: <adar5esn1gd.fsf@cisco.com>
Message-ID: <alpine.LFD.2.00.1011110139200.2900@localhost6.localdomain6>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <39580686-A899-4689-BAAD-AF5546B34E49@mac.com> <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
 <20101107155757.GA13736@kroah.com> <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com> <20101107215908.GA21070@kroah.com> <adar5esn1gd.fsf@cisco.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Roland Dreier wrote:

>  > Isn't the openwrt stuff just drivers and some arch specific code?
>  > Nothing that is core infrastructure, and nothing preventing them from
>  > submitting the drivers and arch code if they want to, right?
> 
> Actually openwrt has some core infrastructure for managing (ethernet)
> switches as extra-fancy multiport PHYs.  That means that all the drivers
> in openwrt for the typical 5-8 port switches in home routers don't
> really apply to mainline.

Why not? Those switches _ARE_ extra-fancy multiport PHYs. And AFAICT
we have no support for this stuff in mainline at all.

So where is the problem ?

Thanks,

	tglx
