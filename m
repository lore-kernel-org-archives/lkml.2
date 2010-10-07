Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab0JGPVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:21:15 -0400
Received: from senator.holtmann.net ([87.106.208.187]:50574 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab0JGPVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:21:14 -0400
Subject: Re: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
From: Marcel Holtmann <marcel@holtmann.org>
To: Greg KH <greg@kroah.com>
Cc: pavan-savoy@ti.com, linux-bluetooth@vger.kernel.org,
        johan.hedberg@gmail.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
In-Reply-To: <20101007143409.GB14913@kroah.com>
References: <1286404493-23816-1-git-send-email-pavan-savoy@ti.com>
	 <1286404493-23816-2-git-send-email-pavan-savoy@ti.com>
	 <1286445948.6145.70.camel@aeonflux>  <20101007143409.GB14913@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 17:21:07 +0200
Message-ID: <1286464867.6145.148.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > > This is the bluetooth protocol driver for the TI WiLink7 chipsets.
> > > Texas Instrument's WiLink chipsets combine wireless technologies
> > > like BT, FM, GPS and WLAN onto a single chip.
> > > 
> > > This Bluetooth driver works on top of the TI_ST shared transport
> > > line discipline driver which also allows other drivers like
> > > FM V4L2 and GPS character driver to make use of the same UART interface.
> > > 
> > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> > > ---
> > >  drivers/bluetooth/bt_ti.c      |  463 ++++++++++++++++++++++++++++++++++++
> > >  drivers/staging/ti-st/bt_drv.c |  509 ----------------------------------------
> > >  drivers/staging/ti-st/bt_drv.h |   61 -----
> > >  3 files changed, 463 insertions(+), 570 deletions(-)
> > >  create mode 100644 drivers/bluetooth/bt_ti.c
> > >  delete mode 100644 drivers/staging/ti-st/bt_drv.c
> > >  delete mode 100644 drivers/staging/ti-st/bt_drv.h
> > 
> > I don't care about staging at all. So you sort that out with Greg.
> > 
> > Submit your driver for upstream inclusion. And once accepted you can pin
> > Greg about removing it.
> 
> The driver is already in staging, this is the request to move it out of
> staging and into the "correct" place in the tree.  The core of the ti-st
> code is now in the drivers/misc/ directory in the linux-next tree, and
> this patch is the request to move the bluetooth drive into the proper
> drivers/bluetooth/ location.

nice idea, but I don't want it that way. I am not dealing with staging
at all. They can submit this driver for upstream inclusion and then
delete it in a second step from staging. Or the other way around.

And as long as this driver registers a Bluetooth HCI device in its
module_init routine it is not ready for upstream. This needs to be fixed
first and I mentioned that already before.

Regards

Marcel


