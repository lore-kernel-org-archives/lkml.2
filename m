Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2JSPyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:54:17 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:3522 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2JSPyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:54:15 -0400
X-IronPort-AV: E=Sophos;i="4.80,613,1344211200"; 
   d="scan'208";a="15280622"
Date: Fri, 19 Oct 2012 16:53:49 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/6]: PVH: basic and header changes, elfnote changes,
 ...
In-Reply-To: <20121019131707.GG26830@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1210191651510.2689@kaball.uk.xensource.com>
References: <20121017172642.349b2aae@mantra.us.oracle.com> <alpine.DEB.2.02.1210181150250.2689@kaball.uk.xensource.com> <20121019131707.GG26830@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012, Konrad Rzeszutek Wilk wrote:
> > > diff --git a/include/xen/interface/physdev.h b/include/xen/interface/physdev.h
> > > index 9ce788d..3b9d5b6 100644
> > > --- a/include/xen/interface/physdev.h
> > > +++ b/include/xen/interface/physdev.h
> > > @@ -258,6 +258,16 @@ struct physdev_pci_device {
> > >      uint8_t devfn;
> > >  };
> > >  
> > > +#define PHYSDEVOP_pvh_map_iomem        30
> > 
> > I would just call this PHYSDEVOP_map_iomem, we might use it on non-PVH
> > guests as well one day.
> 
> I completely lost track of the naming now :-( Isn't the ARM version
> called range something?

That is XENMEM_add_to_physmap_range, a different hypercall.
