Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1HZUqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:46:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39642 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754304Ab1HZUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:46:05 -0400
Date: Fri, 26 Aug 2011 16:46:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Michal Nazarewicz <mnazarewicz@google.com>
cc: Greg KH <greg@kroah.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5 1/4] usb: Provide usb_speed_string() function
In-Reply-To: <op.v0t39bd1vgw7ix@mnazarewicz-glaptop>
Message-ID: <Pine.LNX.4.44L0.1108261645200.5470-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Michal Nazarewicz wrote:

> On Fri, 26 Aug 2011 20:49:05 +0200, Alan Stern <stern@rowland.harvard.edu>  
> wrote:
> > I don't know.  Michal, can you look into this?  What we want is:
> >
> > 	common.o gets included in the main kernel if either CONFIG_USB
> > 	or CONFIG_USB_GADGET is set to Y.
> >
> > 	Otherwise, if either symbol is set to M then common.o gets
> > 	built into its own little module.  Perhaps some other stuff
> > 	could get put in there too, though at the moment I can't
> > 	think of anything.
> 
> Wouldn't that be accomplished by a tristate Kconfig option selected by
> USB and USB_GADGET?  Or a tristate that defaults to “y” but depends on
> USB or USB_GADGET?

Like I said, I don't know.  Try it and see.

Alan Stern

