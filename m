Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0KHQmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 11:42:38 -0500
Received: from kroah.org ([198.145.64.141]:35650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0KHQmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 11:42:37 -0500
Date: Mon, 8 Nov 2010 08:41:25 -0800
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UWB: Return UWB_RSV_ALLOC_NOT_FOUND rather than
 crashing on NULL dereference if kzalloc fails
Message-ID: <20101108164125.GC10892@kroah.com>
References: <alpine.LNX.2.00.1011072158211.26247@swampdragon.chaosbits.net>
 <4CD7F056.6080405@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD7F056.6080405@csr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 12:43:02PM +0000, David Vrabel wrote:
> Jesper Juhl wrote:
> > Hi,
> > 
> > Crashing on a null pointer deref is never a nice thing to do. It seems to 
> > me that it's better to simply return UWB_RSV_ALLOC_NOT_FOUND if kzalloc() 
> > fails in uwb_rsv_find_best_allocation().
> 
> This is fine.
> 
> struct uwb_rsv_alloc_info is not that large (about 414 bytes I think) so
> it could possibly go on the stack and avoid the allocation.
> 
> Acked-by: David Vrabel <david.vrabel@csr.com>
> 
> Greg, seeing as I'm not maintaining the UWB subsystem any more do you
> want to pick this (and future) UWB patches?

Yes, I can do that, and will take this one.

thanks,

greg k-h
