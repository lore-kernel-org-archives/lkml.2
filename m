Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab0DLKtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 06:49:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49267 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0DLKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 06:49:23 -0400
Date: Mon, 12 Apr 2010 12:48:58 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Subject: Re: [LKML] Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100412104858.GT30801@buzzloop.caiaq.de>
References: <20100409202533.GA8983@phenom.dumpdata.com>
 <Pine.LNX.4.44L0.1004091722260.1852-100000@iolanthe.rowland.org>
 <r2n51f3faa71004091511y936975en874a02f7232bb57c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <r2n51f3faa71004091511y936975en874a02f7232bb57c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 04:11:52PM -0600, Robert Hancock wrote:
> On Fri, Apr 9, 2010 at 3:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Fri, 9 Apr 2010, Konrad Rzeszutek Wilk wrote:
> >
> >> On Fri, Apr 09, 2010 at 03:34:06PM -0400, Alan Stern wrote:
> >> > On Fri, 9 Apr 2010, Pedro Ribeiro wrote:
> >> >
> >> > > > The DMA pointers do indeed look sane. I wanted to take a deeper look at
> >> > > > this and set up a 64bit system today. However, I fail to see the problem
> >> > > > here. Pedro, how much RAM does your machine have installed?
> >> >
> >> > > It has 4 GB.
> >> >
> >> > That means DMA mapping cannot be the cause of the problem.  :-(
> >>
> >> That isn't entirely true. The BIOS usually allocates a 256 MB ACPI/PCI hole
> >> that is under the 4GB.
> >>
> >> So end up with 3.7 GB, then the 256MB hole, and then right above the 4GB
> >> you the the remaining memory: 4.3GB.
> >
> > How can Pedro find out what physical addresses are in use on his
> > system?
> 
> If you have 4GB of RAM then almost certainly you have memory located
> at addresses over 4GB. If you look at the e820 memory map printed at
> the start of dmesg on bootup and see entries with addresses of
> 100000000 or higher reported as usable, then this is the case.

Pedro, can you provide your dmesg output, please? I installed 5GB or RAM
to my machine now, and even with your .config, I can't see the problem.

Daniel

