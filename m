Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab2FHP5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:57:41 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:49349 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab2FHP5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:57:39 -0400
Date: Fri, 8 Jun 2012 17:57:29 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
Message-ID: <20120608155728.GB9705@local>
References: <1339156616.3870.9.camel@blech>
 <20120608130351.GB1964@redhat.com>
 <1339165738.3870.18.camel@blech>
 <20120608151843.GA9705@local>
 <1339170312.26423.6.camel@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339170312.26423.6.camel@tesla>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 05:45:12PM +0200, Dominic Eschweiler wrote:
> Am Freitag, den 08.06.2012, 17:18 +0200 schrieb Hans J. Koch:
> > Then there's something fundamentally wrong in your driver. Check the
> > return value of uio_register_device().
> > 
> I'm talking about the uio_pci_generic module, not about UIO in general.
> 
> > > I was very confused when I tried UIO the first time
> > > and it did not behave like it is described in the documentation.
> > 
> > UIO is the mainline since 2007, and I can assure you it works like
> > described. Lots of people use it.
> > 
> I know and I really don't have a problem with UIO itself. The
> uio_pci_generic module does not export correctly, maybe you take a look
> on its code? My guess is, that the uio_pci_generic module isn't commonly
> used and therefore the problem wasn't reported before.

As Michael already said, the intention was to map BAR ressources using
/sys/bus/pci/devices/...

OK, I agree, that's the standard PCI way of doing this, not the standard
UIO way.

What problem do you have with this approach?

Thanks,
Hans
