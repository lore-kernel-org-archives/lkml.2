Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0EXODJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0EXODH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:03:07 -0400
Date: Mon, 24 May 2010 16:03:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Stefan Achatz <erazor_de@users.sourceforge.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: linux-next: build warnings after merge of the driver-core tree
In-Reply-To: <20100521222741.GC12517@kroah.com>
Message-ID: <alpine.LNX.2.00.1005241602320.28092@pobox.suse.cz>
References: <20100521161843.20e795db.sfr@canb.auug.org.au> <20100521164730.GA11173@kroah.com> <alpine.LRH.2.00.1005212330060.14809@twin.jikos.cz> <20100521222741.GC12517@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010, Greg KH wrote:

> > > > drivers/hid/hid-roccat-kone.c:696: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:701: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:703: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:708: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:710: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:715: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:717: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:722: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:724: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:729: warning: initialization from incompatible pointer type
> > > > drivers/hid/hid-roccat-kone.c:731: warning: initialization from incompatible pointer type
> > > > 
> > > > Introduced by commit 867040163f10f2b52b45bc573f330d6eb28f5914 ("sysfs:
> > > > add struct file* to bin_attr callbacks") from the driver-core tree
> > > > interacting with commit 14bf62cde79423a02a590e02664ed29a36facec1 ("HID:
> > > > add driver for Roccat Kone gaming mouse") from the hid tree.
> > > > 
> > > > I added the following patch:
> > > > 
> > > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > Date: Fri, 21 May 2010 16:15:32 +1000
> > > > Subject: [PATCH] hid: fix hid-roccat-kone for bin_attr API change
> > > > 
> > > > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > > > ---
> > > >  drivers/hid/hid-roccat-kone.c |   24 ++++++++++++------------
> > > 
> > > That patch looks fine, but I can't take it in my tree as the HID tree
> > > isn't merged with Linus's tree yet :(
> > 
> > It is merged now, so you can proceed.
> 
> Heh, so is the driver core changes as well.
> 
> Care to take this through your tree as it does only touch drivers/hid/ ?
> 
> Sorry about this.

Yup, I have now applied it to my tree.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
