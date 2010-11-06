Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0KFSXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:23:40 -0400
Received: from kroah.org ([198.145.64.141]:53991 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab0KFSXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:23:39 -0400
Date: Sat, 6 Nov 2010 11:12:02 -0700
From: Greg KH <greg@kroah.com>
To: Elvis Dowson <elvis.dowson@mac.com>
Cc: Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101106181202.GA6927@kroah.com>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com> <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 02:25:31PM -0700, Janakiram Sistla wrote:
> On Sat, Oct 30, 2010 at 11:18 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
> > Hi,
> > ? ? ? I was wondering what the long term implications of android development being forked from the linux mainline are?
> >
> > Android support was removed from 2.6.33 onwards, and development still continues for 2.6.35, by reverting the commit that deleted android from the mainline.
> >
> > One could argue that android gave linux a solid boost widespread adoption for mobile embedded devices, and its use would continue to grow exponentially with time, more than plain vanilla linux for embedded devices.
> >
> > Was removing android from the linux kernel mainline a mistake, in retrospect?

Are you willing to maintain the android kernel code in the mainline
kernel tree?  If so, I will be glad to add it back in, but as no one was
willing to do the work, it was removed.  It's as simple as that.

thanks,

greg k-h
