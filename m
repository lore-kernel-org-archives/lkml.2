Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0GCC2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:28:17 -0400
Received: from kroah.org ([198.145.64.141]:58514 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab0GCC2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:28:15 -0400
Date: Fri, 2 Jul 2010 19:28:09 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>, Brandon <brandon@ifup.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [stable] [stable-2.6.32 PATCH] ixgbe: backport bug fix for tx
 panic
Message-ID: <20100703022809.GA24141@kroah.com>
References: <20100511004655.30590.74584.stgit@localhost.localdomain>
 <AANLkTinHm8ukQ3KlcrMKWvQ-QrlmBcWeVD-i99Q9Z7JL@mail.gmail.com>
 <alpine.WNT.2.00.1005250926320.2708@jbrandeb-desk1.amr.corp.intel.com>
 <20100525201837.GA13821@kroah.com>
 <AANLkTimr7-8TIjuCjIbqrJSVH4VI-Pjp8plpjTubuTfE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimr7-8TIjuCjIbqrJSVH4VI-Pjp8plpjTubuTfE@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:37:13PM -0700, Jeff Kirsher wrote:
> On Tue, May 25, 2010 at 13:18, Greg KH <greg@kroah.com> wrote:
> > On Tue, May 25, 2010 at 09:27:25AM -0700, Brandeburg, Jesse wrote:
> >>
> >>
> >> On Tue, 25 May 2010, Jeff Kirsher wrote:
> >>
> >> > On Mon, May 10, 2010 at 17:46, Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> >> > > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >> > >
> >> > > backporting this commit:
> >> > >
> >> > > commit fdd3d631cddad20ad9d3e1eb7dbf26825a8a121f
> >> > > Author: Krishna Kumar <krkumar2@in.ibm.com>
> >> > > Date:   Wed Feb 3 13:13:10 2010 +0000
> >> > >
> >> > >    ixgbe: Fix return of invalid txq
> >> > >
> >> > >    a developer had complained of getting lots of warnings:
> >> > >
> >> > >    "eth16 selects TX queue 98, but real number of TX queues is 64"
> >> > >
> >> > >    http://www.mail-archive.com/e1000-devel@lists.sourceforge.net/msg02200.html
> >> > >
> >> > >    As there was no follow up on that bug, I am submitting this
> >> > >    patch assuming that the other return points will not return
> >> > >    invalid txq's, and also that this fixes the bug (not tested).
> >> > >
> >> > >    Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> >> > >    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >> > >    Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
> >> > >    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> >> > >    Signed-off-by: David S. Miller <davem@davemloft.net>
> >> > >
> >> > > CC: Brandon <brandon@ifup.org>
> >> > > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >> > > ---
> >> > >
> >> > >  drivers/net/ixgbe/ixgbe_main.c |    8 ++++++--
> >> > >  1 files changed, 6 insertions(+), 2 deletions(-)
> >> > >
> >> >
> >> > Greg - status?  Did you queue this patch for the stable release and I missed it?
> >>
> >> Maybe we didn't say (and we should have) that this fixes a panic on
> >> machines with > 64 cores.  Please apply to -stable 32.
> >
> > I'll get to it for the next release after this one, if that's ok.
> >
> > thanks,
> >
> > greg k-h
> > --
> 
> I did not see this patch in the list of patches for the next release
> of the stable kernel.  Just want to make sure this patch makes it this
> time... :)

Ick, I missed it, let me go queue it up right now, sorry about that.

greg k-h
