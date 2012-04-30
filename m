Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2D3FGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:06:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35918 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2D3FGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:06:03 -0400
Date: Sun, 29 Apr 2012 18:05:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [ 49/62] KVM: unmap pages from the iommu when slots are removed
Message-ID: <20120430010550.GD25022@kroah.com>
References: <20120424223305.GA7748@kroah.com>
 <20120424223246.158425143@linuxfoundation.org>
 <20120427215408.GD2821@burratino>
 <1335564507.3112.473.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335564507.3112.473.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:08:27PM -0600, Alex Williamson wrote:
> On Fri, 2012-04-27 at 16:54 -0500, Jonathan Nieder wrote:
> > Hi,
> > 
> > Greg KH wrote:
> > 
> > > 3.3-stable review patch.
> > [...]
> > > commit 32f6daad4651a748a58a3ab6da0611862175722f upstream.
> > >
> > > We've been adding new mappings, but not destroying old mappings.
> > > This can lead to a page leak
> > 
> > Does 3.0.y need this?
> 
> Yep, same issues exists there.
> 
> >   The patch does not apply as is to 3.0.y because
> > the latter lacks v3.3-rc1~131^2~41 ("KVM: introduce kvm_for_each_memslot
> > macro"), but a backport is straightforward.
> > 
> > Completely untested.  Test results and other comments welcome.
> 
> Looks correct to me.
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>

Wonderful, now applied.
