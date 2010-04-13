Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0DMT1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:27:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44469 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751500Ab0DMT1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:27:36 -0400
Date: Tue, 13 Apr 2010 15:27:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Pedro Ribeiro <pedrib@gmail.com>, <akpm@linux-foundation.org>,
       <linux-usb@vger.kernel.org>, <alsa-devel@alsa-project.org>,
       Robert Hancock <hancockrwd@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] USB: rename usb_buffer_alloc() and usb_buffer_free()
In-Reply-To: <20100413181631.GT30801@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1004131525500.1551-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010, Daniel Mack wrote:

> On Mon, Apr 12, 2010 at 01:17:25PM +0200, Daniel Mack wrote:
> > For more clearance what the functions actually do,
> > 
> >   usb_buffer_alloc() is renamed to usb_alloc_coherent()
> >   usb_buffer_free()  is renamed to usb_free_coherent()
> > 
> > They should only be used in code which really needs DMA coherency.
> > 
> > All call sites have been changed accordingly, except for staging
> > drivers.
> 
> Is this ok? As it's quite big, I think it should be merged soon if there
> are no objections.

I have no objection.  All it does is rename a couple of functions.  
There's no reason for this to go into 2.6.34; it can wait for the next 
merge window.

Alan Stern

