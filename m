Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0DOPUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:20:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55206 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754647Ab0DOPUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:20:45 -0400
Date: Thu, 15 Apr 2010 11:20:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: Chris Wright <chrisw@sous-sol.org>, David Woodhouse <dwmw2@infradead.org>,
       Daniel Mack <daniel@caiaq.de>, USB list <linux-usb@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       <iommu@lists.linux-foundation.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <g2h74fd948d1004141820ladc1941eo732d059dd678df0a@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004151114490.1562-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010, Pedro Ribeiro wrote:

> I enabled  CONFIG_DMAR_BROKEN_GFX_WA=y and the result is the same. A
> delay in the boot process and usb devices don't work properly,
> including my USB mouse.
> 
> Strange, since you have the same platform as me. The extra usb devices
> you were seeing are because of my docking station - but it makes no
> difference whether I'm docked or not for the purposes of the original
> bug or this situation right now. The dmesg I'm attaching is without
> the computer being docked.

It's not possible to determine the reason for the timeout errors
between timestamps 16 and 53 from the small amount of debugging 
information in the log.  Clearly something is going wrong with the 
communication between the computer and the EHCI controller.  And 
clearly the kernel config changes are responsible.

But I don't know what to do to track it down any farther.

Alan Stern

