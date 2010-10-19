Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab0JSXGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 19:06:36 -0400
Received: from kroah.org ([198.145.64.141]:53477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab0JSXGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 19:06:36 -0400
Date: Tue, 19 Oct 2010 16:01:17 -0700
From: Greg KH <greg@kroah.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH v4 00/10] xen: initial domain support
Message-ID: <20101019230117.GA32685@kroah.com>
References: <alpine.DEB.2.00.1010191207010.2423@kaball-desktop>
 <20101019211448.GA10109@kroah.com>
 <4CBE139E.3060004@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBE139E.3060004@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:54:38PM -0700, Jeremy Fitzhardinge wrote:
>  On 10/19/2010 02:14 PM, Greg KH wrote:
> > On Tue, Oct 19, 2010 at 12:16:31PM +0100, Stefano Stabellini wrote:
> >> Hi all,
> >> this series implements the basic support needed to boot Linux as initial
> >> domain on Xen: the target is not to add full featured dom0 support in
> >> the kernel but to be able to boot Linux on Xen on native.
> > Nice, but what real use is this?
> >
> > I thought people wanted dom0 support, this doesn't seem to give them
> > that.  Is that still the end-goal here, and this is merely a
> > stepping-stone to get there?
> 
> Yes, it's a significant step there.  Once that's merged the main missing
> piece is backend drivers, which we can probably get into a mergable form
> for the next window.  And in the meantime, they're a fairly
> self-contained thing to maintain out of tree (like other drivers).

Great.

> Our strategy has been to put together a cluster of patch series which
> each have their own intrinsic value, but are also all leading to full
> dom0 support.  For example, Stefano's pv-hvm patches are useful for
> running Linux as a fully virtualized domain under Xen, but the reworking
> of the interrupt infrastructure in a way that dom0 support requires. 
> Likewise, Konrad's work on pci-passthrough for domU domains adds all the
> machinery required for a Xen domain to have direct access to hardware,
> which is also what dom0 requires.
> 
> This particular series introduces the pieces needed for the kernel to
> actually boot up to usermode as dom0, which has some value even if it
> doesn't yet allow you to start new domains (well, you could, but they
> wouldn't have any devices).
> 
> The net result is that there will be no massive "Xen dom0" patch series,
> since that has been pretty clearly rejected in the past.  Instead full
> dom0 support is being implemented - at least to some extent - as the
> emergent result of a number of Xen-related patches.  These patches also
> touch very little code outside of the existing Xen codebase, so there
> shouldn't be much scope for controversy.

Wonderful, nice job, sounds like a valid plan.

greg k-h
