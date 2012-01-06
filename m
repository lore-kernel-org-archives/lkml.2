Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab2AFPmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:42:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48373 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030360Ab2AFPmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:42:44 -0500
Date: Fri, 6 Jan 2012 10:42:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Problems with get_driver() and driver_attach() (and new_id too)
In-Reply-To: <20120105231731.GA15539@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1201061039590.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012, Greg KH wrote:

> > Greg, do you know offhand whether this will break anything?  It really 
> > seems like the right thing to do, because the usb_serial driver uses 
> > the usb driver but not vice versa.
> 
> Hm, there was a reason I ordered the way I did, as I remember having to
> go fix up a number of drivers that did it in the reverse order.  Give me
> a day or so to dig it up and figure out what is going on here, and to
> review this thread.

One more thing.  I just noticed that, unlike all the others, the
qcserial and siemens_mpi modules don't set .no_dynamic_id in their
usb_driver structures.  Is that just an oversight?  I can't think of 
any reason for it.

Alan Stern

