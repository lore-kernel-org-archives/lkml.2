Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0KGQ2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 11:28:51 -0500
Received: from kroah.org ([198.145.64.141]:44491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0KGQ2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 11:28:50 -0500
Date: Sun, 7 Nov 2010 07:57:58 -0800
From: Greg KH <greg@kroah.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101107155757.GA13736@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <39580686-A899-4689-BAAD-AF5546B34E49@mac.com> <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 01:44:45PM +0200, Anca Emanuel wrote:
> On Sun, Nov 7, 2010 at 10:38 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> > HI Greg,
> >
> > On Nov 6, 2010, at 10:12 PM, Greg KH wrote:
> >
> >> Are you willing to maintain the android kernel code in the mainline
> >> kernel tree? ?If so, I will be glad to add it back in, but as no one was
> >> willing to do the work, it was removed. ?It's as simple as that.
> >
> > I'm willing to do this. I'll start off initially with support for TI OMAP 35xx
> > and TI OMAP 4440, build and test initially on the Gumstix Overo,
> > BeagleBoard and PandaBoard.
> >
> > I'll start with v2.6.37-rc1 and android-froyo-2.2, and try to do the required
> > changes to get it accepted into mainline by v2.6.39.
> >
> > Elvis Dowson
> 
> Read this: https://wiki.linaro.org/Releases/1105?action=AttachFile&do=get&target=Linaro+Cycle+2+Requirements+18+September+2010.pdf
> ( http://is.gd/gNP7y )
> 
> [quote]
> Android Strategy
> Sponsor: Yves V. (Freescale)
> Leads: Lo?c, Scott B.
> WGs: Kernel Consolidation, Toolchain
> ...
> 
> A2.2 Support upstreaming of Android patches
> [/quote]
> 
> Linaro is going in the same direction.

That does not mean they will actually ever get to that work, or achieve
it...
