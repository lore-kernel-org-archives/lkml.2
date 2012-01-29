Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2A2EaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 23:30:24 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35011 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752954Ab2A2EaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 23:30:22 -0500
X-Sasl-enc: rdbmHW5TtltCvt/Drxr4FgLhkhibeYptBX8ZRY6RCtt6 1327811421
Date: Sat, 28 Jan 2012 20:30:10 -0800
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: =?iso-8859-1?Q?Jos=E9?= Antonio Matute <matutet@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qcserial: add support for Huawei Gobi 3000 devices
Message-ID: <20120129043010.GA27141@kroah.com>
References: <CAFQ_mD6DThCcsvy5=A0sMVBn-1mhwyTeGsM8GpSS__5zDU6K-A@mail.gmail.com>
 <4F2411F4.6040403@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F2411F4.6040403@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 28, 2012 at 07:19:16PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 28-01-2012 13:11, José Antonio Matute wrote:
> 
> >From: Jose Antonio Matute<matutet@gmail.com>
> 
>   Should be an empty line here, no?
> 
> >Add USB IDs for Huawei Gobi 3000 devices (some of which are rebranded
> >as Sony Vaio VPCSA modems).
> 
> >Signed-off-by: Jose Antonio Matute<matutet@gmail.com>
> >Cc: stable@vger.kernel.org
> >---
> >--- linux-3.3-rc1/drivers/usb/serial/qcserial.c.orig	2012-01-28
> >09:43:01.088140483 +0100
> >+++ linux-3.3-rc1/drivers/usb/serial/qcserial.c	2012-01-28
> >09:46:37.908131967 +0100
> >@@ -87,6 +87,7 @@ static const struct usb_device_id id_tab
> >  	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
> >  	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
> >  	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem
> >device (MC8355) */
> 
>    The patch is line wrapped; seems ealsy to fix tho...

I will fix it by hand for this simple thing, don't worry, the patch is
fine.

greg k-h
