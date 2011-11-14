Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1KNVCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 16:02:45 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16468 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754718Ab1KNVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 16:02:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dARjWMwWEj7DlZ6R1tCua
Date: Mon, 14 Nov 2011 13:02:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 5/5] iommu/omap: eliminate the public
 omap_find_iommu_device() method
Message-ID: <20111114210236.GO31337@atomide.com>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com>
 <201109271346.13791.laurent.pinchart@ideasonboard.com>
 <CAK=WgbZaZTT=PsrvY8QTypuViknCK=APHogZLg5SjSN3_C=odw@mail.gmail.com>
 <201111091017.41947.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201111091017.41947.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [111109 00:42]:
> Hi Ohad,
> 
> On Wednesday 09 November 2011 09:50:30 Ohad Ben-Cohen wrote:
> > On Tue, Sep 27, 2011 at 2:46 PM, Laurent Pinchart wrote:
> > > On Sunday 25 September 2011 12:58:57 Ohad Ben-Cohen wrote:
> > >> Eliminate the public omap_find_iommu_device() method, and don't
> > >> expect clients to provide the omap_iommu handle anymore.
> > >> 
> > >> Instead, OMAP's iommu driver should now utilize dev_archdata's private
> > >> iommu extension to be able to access the required iommu information.
> > >> 
> > >> Update omap3isp appropriately.
> > >> 
> > >> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> > >> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > >> Cc: Tony Lindgren <tony@atomide.com>
> > > 
> > > For the OMAP3 ISP driver,
> > > 
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > Thanks !
> > 
> > Can you please also ack the 4th patch in this series (that's the part
> > the makes this fifth patch possible):
> > 
> > https://lkml.org/lkml/2011/9/25/46
> 
> Sure. Done.
> 
> > I could then ask Tony to Ack it so we could merge this via the iommu tree.

This too:

Acked-by: Tony Lindgren <tony@atomide.com>
