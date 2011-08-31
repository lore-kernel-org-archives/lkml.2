Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1HaS4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 14:56:55 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43814 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab1HaS4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 14:56:54 -0400
X-Sasl-enc: yfLrZyRgPmjlHYT7ZZF9opJIV+Xb1+IqPig682R1SY9U 1314817013
Date: Wed, 31 Aug 2011 11:51:10 -0700
From: Greg KH <greg@kroah.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: Please back-port git commit
 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9 and
 89153b5cae9f40c224a5d321665a97bf14220c2c to 3.0.x
Message-ID: <20110831185110.GA11782@kroah.com>
References: <20110822152354.GA24763@dumpdata.com>
 <1314778698.28989.28.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314778698.28989.28.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 09:18:18AM +0100, Ian Campbell wrote:
> On Mon, 2011-08-22 at 11:23 -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> > 
> > I've two patches that are in Linus's upstream kernel, but I neglected to
> > put the stable@kernel.org on them (duh!). Both Fedora and Ubuntu are carrying
> > those two patches - but it would be nice if other distros got them.
> > 
> > The two patches are:
> > 
> > commit 196cfe2ae8fcdc03b3c7d627e7dfe8c0ce7229f9
> > Author: Stefan Bader <stefan.bader@canonical.com>
> > Date:   Thu Jul 14 15:30:22 2011 +0200
> > 
> >     xen-blkfront: Drop name and minor adjustments for emulated scsi devices
> > 
> > commit 89153b5cae9f40c224a5d321665a97bf14220c2c
> > Author: Stefan Bader <stefan.bader@canonical.com>
> > Date:   Thu Jul 14 15:30:37 2011 +0200
> > 
> >     xen-blkfront: Fix one off warning about name clash
> > 
> > Please back-port them to 3.0.x kernel. Thank 
> 
> On a related note having this in stable/longterm (including 2.6.32.y)
> seems like a good idea? (it was already in the 3.0 baseline)
> 
> commit 4352b47ab7918108b389a48d2163c9a4c2aaf139
> Author: Marek Marczykowski <marmarek@mimuw.edu.pl>
> Date:   Tue May 3 12:04:52 2011 -0400
> 
>     xen-blkfront: fix data size for xenbus_gather in blkfront_connect
>     
>     barrier variable is int, not long. This overflow caused another variable
>     override: "err" (in PV code) and "binfo" (in xenlinux code -
>     drivers/xen/blkfront/blkfront.c). The later caused incorrect device
>     flags (RO/removable etc).
>     
>     Signed-off-by: Marek Marczykowski <marmarek@mimuw.edu.pl>
>     Acked-by: Ian Campbell <Ian.Campbell@citrix.com>
>     [v1: Changed title]
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

It might, but it doesn't seem to apply to the .32 or .33-longterm
kernels at all, so I would need a backported version to be able to apply
it successfully.

thanks,

greg k-h
