Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab0JGU45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:56:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0JGU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:56:56 -0400
Date: Thu, 7 Oct 2010 14:57:15 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>, pavan-savoy@ti.com,
        linux-bluetooth@vger.kernel.org, johan.hedberg@gmail.com,
        linux-kernel@vger.kernel.org, Pavan Savoy <pavan_savoy@ti.com>
Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Message-ID: <20101007175715.GA13602@vigoh>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
 <1286445948.6145.70.camel@aeonflux>
 <20101007143409.GB14913@kroah.com>
 <1286464867.6145.148.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286464867.6145.148.camel@aeonflux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Marcel Holtmann <marcel@holtmann.org> [2010-10-07 17:21:07 +0200]:

> Hi Greg,
> 
> > > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > > like BT, FM, GPS and WLAN onto a single chip.
> > > > 
> > > > This Bluetooth driver works on top of the TI_ST shared transport
> > > > line discipline driver which also allows other drivers like
> > > > FM V4L2 and GPS character driver to make use of the same UART interface.
> > > > 
> > > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > > ---
> > > >  drivers/bluetooth/bt_ti.c      |  463 ++++++++++++++++++++++++++++++++++++
> > > >  drivers/staging/ti-st/bt_drv.c |  509 ----------------------------------------
> > > >  drivers/staging/ti-st/bt_drv.h |   61 -----
> > > >  3 files changed, 463 insertions(+), 570 deletions(-)
> > > >  create mode 100644 drivers/bluetooth/bt_ti.c
> > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.c
> > > >  delete mode 100644 drivers/staging/ti-st/bt_drv.h
> > > 
> > > I don't care about staging at all. So you sort that out with Greg.
> > > 
> > > Submit your driver for upstream inclusion. And once accepted you can pin
> > > Greg about removing it.
> > 
> > The driver is already in staging, this is the request to move it out of
> > staging and into the "correct" place in the tree.  The core of the ti-st
> > code is now in the drivers/misc/ directory in the linux-next tree, and
> > this patch is the request to move the bluetooth drive into the proper
> > drivers/bluetooth/ location.
> 
> nice idea, but I don't want it that way. I am not dealing with staging
> at all. They can submit this driver for upstream inclusion and then
> delete it in a second step from staging. Or the other way around.

We just have to be sure to do both steps in the same release cycle,
otherwise we could ship the driver twice in the kernel (considering we
will delete it after merge in drivers/bluetooth/)

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
