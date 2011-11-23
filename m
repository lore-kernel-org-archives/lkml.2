Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1KWQ1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:27:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46990 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753866Ab1KWQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:27:33 -0500
Date: Wed, 23 Nov 2011 11:27:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: [regression 3.1.0 -> 3.20rc] USB Oops
In-Reply-To: <20111122231656.GB15722@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.1111231126470.2111-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011, Norbert Preining wrote:

> On Di, 22 Nov 2011, Alan Stern wrote:
> > > [   67.852328] BUG: unable to handle kernel NULL pointer dereference at 00000000000002d9
> > > [   67.853898] IP: [<ffffffffa0249e6b>] last_sector_hacks.part.2+0x72/0xe0 [usb_storage]
> > 
> > This is odd.  I've never seen a problem in that routine before.
> > 
> > What is "last_sector_hacks.part.2"?  In my kernel source tree there is
> > a last_sector_hacks() function in drivers/usb/storage/transport.c, but
> > what does the ".part.2" refer to?
> 
> No idea, here I am compiling with default Debian sid gcc, that is
> gcc (Debian 4.6.2-4) 4.6.2
> 
> Anything else I can do? Should I hack something into the code?

See the other questions in my previous email message (you cut them out
of this reply).

Alan Stern

