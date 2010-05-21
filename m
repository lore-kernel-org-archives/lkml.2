Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0EUWbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:31:20 -0400
Received: from kroah.org ([198.145.64.141]:53024 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab0EUWbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:31:18 -0400
Date: Fri, 21 May 2010 15:27:41 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: linux-next: build warnings after merge of the driver-core tree
Message-ID: <20100521222741.GC12517@kroah.com>
References: <20100521161843.20e795db.sfr@canb.auug.org.au>
 <20100521164730.GA11173@kroah.com>
 <alpine.LRH.2.00.1005212330060.14809@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1005212330060.14809@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:30:37PM +0200, Jiri Kosina wrote:
> On Fri, 21 May 2010, Greg KH wrote:
> 
> > > drivers/hid/hid-roccat-kone.c:694: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:696: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:701: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:703: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:708: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:710: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:715: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:717: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:722: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:724: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:729: warning: initialization from incompatible pointer type
> > > drivers/hid/hid-roccat-kone.c:731: warning: initialization from incompatible pointer type
> > > 
> > > Introduced by commit 867040163f10f2b52b45bc573f330d6eb28f5914 ("sysfs:
> > > add struct file* to bin_attr callbacks") from the driver-core tree
> > > interacting with commit 14bf62cde79423a02a590e02664ed29a36facec1 ("HID:
> > > add driver for Roccat Kone gaming mouse") from the hid tree.
> > > 
> > > I added the following patch:
> > > 
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Fri, 21 May 2010 16:15:32 +1000
> > > Subject: [PATCH] hid: fix hid-roccat-kone for bin_attr API change
> > > 
> > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > ---
> > >  drivers/hid/hid-roccat-kone.c |   24 ++++++++++++------------
> > 
> > That patch looks fine, but I can't take it in my tree as the HID tree
> > isn't merged with Linus's tree yet :(
> 
> It is merged now, so you can proceed.

Heh, so is the driver core changes as well.

Care to take this through your tree as it does only touch drivers/hid/ ?

Sorry about this.

thanks,

greg k-h
