Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab0HJUQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:16:53 -0400
Received: from kroah.org ([198.145.64.141]:57752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944Ab0HJUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:16:48 -0400
Date: Tue, 10 Aug 2010 13:16:39 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [Stable-review] [116/165] ext4: dont return to
 userspace after freezing the fs with a mutex held
Message-ID: <20100810201639.GC12680@kroah.com>
References: <20100730171510.105264205@clark.site>
 <4C56B45E.9010601@canonical.com>
 <4C56FA35.7060607@redhat.com>
 <20100802184806.GA16878@kroah.com>
 <20100807040732.GB16342@khazad-dum.debian.net>
 <4C5D61E7.9090008@redhat.com>
 <4C5FC3BB.4030602@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5FC3BB.4030602@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:00:43AM +0200, Stefan Bader wrote:
> On 08/07/2010 03:38 PM, Eric Sandeen wrote:
> > Henrique de Moraes Holschuh wrote:
> >> On Mon, 02 Aug 2010, Greg KH wrote:
> >>> On Mon, Aug 02, 2010 at 12:02:45PM -0500, Eric Sandeen wrote:
> >>>> On 08/02/2010 07:04 AM, Stefan Bader wrote:
> >>>>> We have reports about this patch breaking lvm snapshhots. Eric, there is a patch
> >>>>> mentioned which is supposed to fix things but its not upstream, yet.
> >>>>> Do you know what happened to that?
> >>>> right, patch below is needed to fix things.
> >>>>
> >>>> Ted just acked it on the list recently; Greg, I'd either drop 116/165
> >>>> for now, or include the patch below which should be upstream soon...
> >>> I can't take anything that isn't upstream yet.
> >>>
> >>> And I just released with this patch in the kernel, should I do a revert
> >>> and do a new release?
> >>
> >> Any answers on this?
> >>
> > 
> > Yes, I'd revert it for now, I'm afraid, if the other patch isn't upstream
> > yet.
> > 
> > Sorry about that,
> > 
> > -Eric
> 
> Upstream as of now (same SHA1 as in linux-next):
> 
> >From 437f88cc031ffe7f37f3e705367f4fe1f4be8b0f Mon Sep 17 00:00:00 2001
> From: Eric Sandeen <sandeen@sandeen.net>
> Date: Sun, 1 Aug 2010 17:33:29 -0400
> Subject: [PATCH] (pre-stable) ext4: fix freeze deadlock under IO

It looks like I can't drop the original one, as this patch builds on it.
So I'll just queue this one up.

Should it also go into other -stable releases (like .35 and/or .34 -stable?)

thanks,

greg k-h
