Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362Ab0J1Sae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:30:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36379 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab0J1Saa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:30:30 -0400
Date: Thu, 28 Oct 2010 20:30:24 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>, Greg KH <gregkh@suse.de>,
        matthieu.castet@parrot.com, stern@rowland.harvard.edu,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for .37-rc1
Message-ID: <20101028183024.GA31158@pengutronix.de>
References: <20101022175102.GA13489@kroah.com> <86A0E76937111F4C92FABEC0A2098851051D62E6@az33exm21> <20101028181519.GD2573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101028181519.GD2573@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 11:15:19AM -0700, Greg KH wrote:
> On Mon, Oct 25, 2010 at 04:33:27PM -0700, Nguyen Dinh-R00091 wrote:
> > Hi Greg,
> > 
> > It seems that this commit is breaking ehci-mxc build for MX51.
> > 
> > USB: ehci tdi : let's tdi_reset set host mode
> > Commit # 65fd42724aee31018b0bb53f4cb04971423be664
> > 
> > >Matthew Garrett (1):
> > >      USB: serial: Enable USB autosuspend by default on qcserial
> > >
> > 
> > The error is:
> > 
> > drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
> > drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)
> 
> Care to send a build fix for it?
I reported that issue, too:
http://thread.gmane.org/gmane.linux.usb.general/35817/focus=38096

it contains a patch that fixes the build but isn't confirmed to work,
yet.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
