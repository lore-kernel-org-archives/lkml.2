Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1HIVTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:19:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38403 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752384Ab1HIVTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:19:00 -0400
Date: Tue, 9 Aug 2011 17:19:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-bluetooth@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] BTUSB: be quiet on device disconnect
In-Reply-To: <1312921583.30382.12.camel@t41.thuisdomein>
Message-ID: <Pine.LNX.4.44L0.1108091717440.1949-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Paul Bolle wrote:

> On Tue, 2011-08-09 at 12:00 -0400, Alan Stern wrote:
> > On Tue, 9 Aug 2011, Paul Bolle wrote:
> > > 1) I added Greg and linux-usb@vger.kernel.org because usb_submit_urb()
> > > doesn't specify the meaning of its negative return values. I traced
> > 
> > In fact, many of these values are documented in 
> > Documentation/usb/error-codes.txt.
> 
> 0) Thanks. I hadn't found that, obviously.
> 
> 1) Would it make sense to add links to that file in the documentation
> for usb_submit_urb() and other core usb functions? (Does the kernel-doc
> syntax have a notation for links?) I only do hit-and-run patches in the
> usb subsystem, and any other subsystem, for that matter, so I'm not sure
> that what I like to see is what's actually needed.

I don't know...  It's really up to Greg KH.  You could send in a patch 
and see if he likes it.  :-)

Alan Stern

