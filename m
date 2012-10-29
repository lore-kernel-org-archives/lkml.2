Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab2J2XBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 19:01:51 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46774 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2J2XBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 19:01:50 -0400
Date: Mon, 29 Oct 2012 16:01:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
Message-ID: <20121029230146.GA22320@kroah.com>
References: <508E58FD.2000707@ahsoftware.de>
 <508E8264.8070807@ahsoftware.de>
 <20121029165946.GB6614@kroah.com>
 <508EC69F.2030505@ahsoftware.de>
 <20121029183250.GB4623@kroah.com>
 <508EDEC6.7030101@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508EDEC6.7030101@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 08:53:42PM +0100, Alexander Holler wrote:
> Am 29.10.2012 19:32, schrieb Greg Kroah-Hartman:
> >On Mon, Oct 29, 2012 at 07:10:39PM +0100, Alexander Holler wrote:
> >>Am 29.10.2012 17:59, schrieb Greg Kroah-Hartman:
> >>>On Mon, Oct 29, 2012 at 02:19:32PM +0100, Alexander Holler wrote:
> >>>>Am 29.10.2012 11:22, schrieb Alexander Holler:
> >>>>>Hello,
> >>>>>
> >>>>>I've just bisected a problem with 3.6.4.
> >>>>>
> >>>>>I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6
> >>>>>(1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box
> >>>>>didn't boot.
> >>>>>
> >>>>>I can't provide any output, because I don't see if that commit is
> >>>>>applied. ;)
> >>>>
> >>>>That sentence missed an 'any'. But I've now attached a serial, here is
> >>>>the output:
> >>>
> >>>Thanks for this, it should be fixed in the next 3.6.y release, we needed
> >>>to add two more commits from upstream:
> >>>	844ab6f993b1d32eb40512503d35ff6ad0c57030
> >>>	f82f64dd9f485e13f29f369772d4a0e868e5633a
> >>>If you apply those two, and it doesn't solve the problem for you, please
> >>>let us know.
> >>
> >>They don't applied cleanly, but after fixing the conflicts it seem's
> >>to work.
> >
> >The conflict was in the printk, right?  I fixed that up in the 3.4
> >stable tree.
> 
> No, I've come up with that on top of 3.6.4:

Really?  That's odd.

Can you test out 3.6.5-rc1 and see if that works properly for you or
not?  It should have all of the fixes in it already.

thanks,

greg k-h
