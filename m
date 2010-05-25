Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730Ab0EYSW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:22:26 -0400
Received: from kroah.org ([198.145.64.141]:44515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086Ab0EYSWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:22:21 -0400
Date: Tue, 25 May 2010 11:19:35 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: stable@kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brandon <brandon@ifup.org>, davem@davemloft.net
Subject: Re: [stable] [stable-2.6.32 PATCH] ixgbe: backport bug fix for tx
 panic
Message-ID: <20100525181935.GA11150@kroah.com>
References: <20100511004655.30590.74584.stgit@localhost.localdomain>
 <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 12:15:12AM -0700, Jeff Kirsher wrote:
> On Mon, May 10, 2010 at 17:46, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >
> > backporting this commit:
> >
> > commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
> > Author: Krishna Kumar <krkumar2@in.ibm.com>
> > Date:   Wed Feb 3 13:13:10 2010 +0000
> >
> >    ixgbe: Fix return of invalid txq
> >
> >    a developer had complained of getting lots of warnings:
> >
> >    "eth16 selects TX queue 98, but real number of TX queues is 64"
> >
> >    http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html
> >
> >    As there was no follow up on that bug, I am submitting this
> >    patch assuming that the other return points will not return
> >    invalid txq's, and also that this fixes the bug (not tested).
> >
> >    Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> >    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >    Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> >    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> >    Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > CC: Brandon <brandon@ifup.org>
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> >
> >  drivers/net/ixgbe/ixgbe_main.c |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> >
> 
> Greg - status?  Did you queue this patch for the stable release and I missed it?

Nope, I missed it, sorry.

I'll make sure to get it for the next .32 round.

thanks,

greg k-h
