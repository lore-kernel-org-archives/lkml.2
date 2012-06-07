Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab2FGIHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:07:18 -0400
Received: from www84.your-server.de ([213.133.104.84]:37987 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab2FGIHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:07:07 -0400
Message-ID: <1339056445.4964.2.camel@wall-e>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, alan@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 10:07:25 +0200
In-Reply-To: <20120606225426.GA8270@kroah.com>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
	 <1339000032-10313-5-git-send-email-stefani@seibold.net>
	 <20120606225426.GA8270@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.06.2012, 07:54 +0900 schrieb Greg KH:
> On Wed, Jun 06, 2012 at 06:27:05PM +0200, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > this saves a litte bit of memory space in the driver devices structure
> > 
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  drivers/usb/usb-skeleton.c |   23 ++++++++++++-----------
> >  1 files changed, 12 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> > index 2f17991..f7fe32f 100644
> > --- a/drivers/usb/usb-skeleton.c
> > +++ b/drivers/usb/usb-skeleton.c
> > @@ -49,7 +49,6 @@ MODULE_DEVICE_TABLE(usb, skel_table);
> >  /* Structure to hold all of our device specific stuff */
> >  struct usb_skel {
> >  	struct usb_device	*udev;			/* the usb device for this device */
> > -	struct usb_interface	*interface;		/* the interface for this device */
> 
> No, that's the exact opposite of what I asked you to do.
> 

You asked me "Do you really need both?". But anyway i will find no way
to kick the usb_device pointer away without wasting the code.

So i will revert it for the first time.
 


