Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab0J1SVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:21:46 -0400
Received: from kroah.org ([198.145.64.141]:46304 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761148Ab0J1SVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:21:31 -0400
Date: Thu, 28 Oct 2010 11:15:19 -0700
From: Greg KH <greg@kroah.com>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Greg KH <gregkh@suse.de>, matthieu.castet@parrot.com,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [GIT PATCH] USB patches for .37-rc1
Message-ID: <20101028181519.GD2573@kroah.com>
References: <20101022175102.GA13489@kroah.com>
 <86A0E76937111F4C92FABEC0A2098851051D62E6@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86A0E76937111F4C92FABEC0A2098851051D62E6@az33exm21>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 04:33:27PM -0700, Nguyen Dinh-R00091 wrote:
> Hi Greg,
> 
> It seems that this commit is breaking ehci-mxc build for MX51.
> 
> USB: ehci tdi : let's tdi_reset set host mode
> Commit # 65fd42724aee31018b0bb53f4cb04971423be664
> 
> >Matthew Garrett (1):
> >      USB: serial: Enable USB autosuspend by default on qcserial
> >
> 
> The error is:
> 
> drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
> drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)

Care to send a build fix for it?

thanks,

greg k-h
