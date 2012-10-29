Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121Ab2J2Q7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:59:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:34833 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759406Ab2J2Q7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:59:48 -0400
Date: Mon, 29 Oct 2012 09:59:46 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: x86: Regression in 3.6.4, bisected to "Exclude E820_RESERVED
 regions..."
Message-ID: <20121029165946.GB6614@kroah.com>
References: <508E58FD.2000707@ahsoftware.de>
 <508E8264.8070807@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508E8264.8070807@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 02:19:32PM +0100, Alexander Holler wrote:
> Am 29.10.2012 11:22, schrieb Alexander Holler:
> >Hello,
> >
> >I've just bisected a problem with 3.6.4.
> >
> >I had to revert commit 54ce8ce298f382a06186cb4672ad6aa090b050b6
> >(1bbbbe779aabe1f0768c2bf8f8c0a5583679b54a in mainline), otherwise my box
> >didn't boot.
> >
> >I can't provide any output, because I don't see if that commit is
> >applied. ;)
> 
> That sentence missed an 'any'. But I've now attached a serial, here is
> the output:

Thanks for this, it should be fixed in the next 3.6.y release, we needed
to add two more commits from upstream:
	844ab6f993b1d32eb40512503d35ff6ad0c57030
	f82f64dd9f485e13f29f369772d4a0e868e5633a
If you apply those two, and it doesn't solve the problem for you, please
let us know.

thanks,

greg k-h
