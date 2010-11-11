Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694Ab0KKAyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:54:13 -0500
Received: from kroah.org ([198.145.64.141]:35024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab0KKAyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:54:11 -0500
Date: Wed, 10 Nov 2010 16:47:30 -0800
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Anca Emanuel <anca.emanuel@gmail.com>,
        Elvis Dowson <elvis.dowson@mac.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101111004730.GC22463@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com> <20101106181202.GA6927@kroah.com> <39580686-A899-4689-BAAD-AF5546B34E49@mac.com> <AANLkTimVsUsrmTvsHqFiqJh1hhryMBemGyW+kYLKGgEu@mail.gmail.com> <20101107155757.GA13736@kroah.com> <AANLkTik=UWwRLOaHMfVifYiQPpSwoYuA6J1EoL5BOgJY@mail.gmail.com> <20101107215908.GA21070@kroah.com> <adar5esn1gd.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar5esn1gd.fsf@cisco.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:33:38PM -0800, Roland Dreier wrote:
>  > Isn't the openwrt stuff just drivers and some arch specific code?
>  > Nothing that is core infrastructure, and nothing preventing them from
>  > submitting the drivers and arch code if they want to, right?
> 
> Actually openwrt has some core infrastructure for managing (ethernet)
> switches as extra-fancy multiport PHYs.  That means that all the drivers
> in openwrt for the typical 5-8 port switches in home routers don't
> really apply to mainline.

Why can't we merge that core infrastructure as well?  Has it been
rejected for any specific reasons?

thanks,

greg k-h
