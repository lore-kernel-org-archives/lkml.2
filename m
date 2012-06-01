Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab2FAQBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:01:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39037 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965186Ab2FAQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:01:13 -0400
Date: Fri, 1 Jun 2012 17:17:09 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, Steven Harms <sjharms@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.0.y, 3.2.y] Re: [PATCH 1/1] Add Foxconn / Hon Hai IDs for
 btusb module
Message-ID: <20120601091709.GB22821@kroah.com>
References: <1334342755-7371-1-git-send-email-sjharms@gmail.com>
 <20120529120312.GA16584@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529120312.GA16584@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:03:12AM -0500, Jonathan Nieder wrote:
> Hi Ben and Greg,
> 
> Steven Harms wrote:
> 
> > This change adds 0x0489:0xe033 to the btusb module.
> >
> > This bluetooth usb device is integrated in the Acer TimelineX
> > AS4830TG-6808 notebook.
> [...]
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -107,6 +107,9 @@ static struct usb_device_id btusb_table[] = {
> >  	{ USB_DEVICE(0x0a5c, 0x21f3) },
> >  	{ USB_DEVICE(0x413c, 0x8197) },
> >  
> > +	/* Foxconn - Hon Hai */
> > +	{ USB_DEVICE(0x0489, 0xe033) },
> > +
> >  	{ }	/* Terminating entry */
> 
> Please consider
> 
>   985140369be1 Add Foxconn / Hon Hai IDs for btusb module
> 
> for application to the 3.0.y and 3.2.y kernels.  The driver was
> tested by Steven Harms on a Acer TimelineX AS4830TG-6808 using
> Ubuntu's 3.2.y-based kernel: http://www.sharms.org/blog/2012/04/

Applied to 3.0-stable, thanks.
