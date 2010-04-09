Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab0DIVX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:23:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38338 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757769Ab0DIVXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:23:23 -0400
Date: Fri, 9 Apr 2010 17:23:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Pedro Ribeiro <pedrib@gmail.com>, Daniel Mack <daniel@caiaq.de>,
       Robert Hancock <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       <alsa-devel@alsa-project.org>, <linux-usb@vger.kernel.org>
Subject: Re: [LKML] Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100409202533.GA8983@phenom.dumpdata.com>
Message-ID: <Pine.LNX.4.44L0.1004091722260.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Konrad Rzeszutek Wilk wrote:

> On Fri, Apr 09, 2010 at 03:34:06PM -0400, Alan Stern wrote:
> > On Fri, 9 Apr 2010, Pedro Ribeiro wrote:
> > 
> > > > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> > > > this and set up a 64bit system today. However, I fail to see the problem
> > > > here. Pedro, how much RAM does your machine have installed?
> > 
> > > It has 4 GB.
> > 
> > That means DMA mapping cannot be the cause of the problem.  :-(
> 
> That isn't entirely true. The BIOS usually allocates a 256 MB ACPI/PCI hole
> that is under the 4GB.
> 
> So end up with 3.7 GB, then the 256MB hole, and then right above the 4GB
> you the the remaining memory: 4.3GB.

How can Pedro find out what physical addresses are in use on his 
system?

Alan Stern

