Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab0JGWIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:08:48 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43618 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0JGWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:08:47 -0400
Date: Thu, 7 Oct 2010 16:09:06 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Greg KH <greg@kroah.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, pavan-savoy@ti.com,
        linux-bluetooth@vger.kernel.org, johan.hedberg@gmail.com,
        linux-kernel@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Message-ID: <20101007190906.GE4893@vigoh>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
 <1286445948.6145.70.camel@aeonflux>
 <20101007143409.GB14913@kroah.com>
 <20101007175148.GC4893@vigoh>
 <20101007213018.GA28043@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007213018.GA28043@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [2010-10-07 14:30:18 -0700]:

> On Thu, Oct 07, 2010 at 02:51:48PM -0300, Gustavo F. Padovan wrote:
> > Hi Greg,
> > 
> > * Greg KH <greg@kroah.com> [2010-10-07 07:34:09 -0700]:
> > 
> > > On Thu, Oct 07, 2010 at 12:05:48PM +0200, Marcel Holtmann wrote:
> > > > Hi Pavan,
> > > > 
> > > > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > > > like BT, FM, GPS and WLAN onto a single chip.
> > > > > 
> > > > > This Bluetooth driver works on top of the TI_ST shared transport
> > > > > line discipline driver which also allows other drivers like
> > > > > FM V4L2 and GPS character driver to make use of the same UART interface.
> > > > > 
> > > > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > > > ---
> > > > >  drivers/bluetooth/bt_ti.c      |  463 ++++++++++++++++++++++++++++++++++++
> > > > >  drivers/staging/ti-st/bt_drv.c |  509 ----------------------------------------
> > > > >  drivers/staging/ti-st/bt_drv.h |   61 -----
> > > > >  3 files changed, 463 insertions(+), 570 deletions(-)
> > > > >  create mode 100644 drivers/bluetooth/bt_ti.c
> > > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.c
> > > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.h
> > > > 
> > > > I don't care about staging at all. So you sort that out with Greg.
> > > > 
> > > > Submit your driver for upstream inclusion. And once accepted you can pin
> > > > Greg about removing it.
> > > 
> > > The driver is already in staging, this is the request to move it out of
> > > staging and into the "correct" place in the tree.  The core of the ti-st
> > > code is now in the drivers/misc/ directory in the linux-next tree, and
> > > this patch is the request to move the bluetooth drive into the proper
> > > drivers/bluetooth/ location.
> > 
> > I'm wondering why this driver never touched linux-bluetooth before. It
> > is on staging because it is not ready for a proper merge and while it is
> > not ready it needs the comments from the bluetooth developers here to
> > get it ready for merge in drivers/bluetooth. So why this never arrived 
> > here before?
> 
> This is the exact reason _why_ it is being sent here now.  To get the
> review of the bluetooth developers for any changes that are needed to
> get it merged into the proper place in the tree.

Yes, but IMHO it took to long, from what I looked this drivers was merged
in stage about May and the patches arrived in linux-bluetooth only in
October. Is there a reason for such delay?  That's is something we need
to fix for the next bluetooth drivers we want to merge, so the developers
can get feedback earlier.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
