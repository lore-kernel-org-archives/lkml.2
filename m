Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1KIJRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 04:17:43 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52088 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab1KIJRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 04:17:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 5/5] iommu/omap: eliminate the public omap_find_iommu_device() method
Date: Wed, 9 Nov 2011 10:17:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.3; x86_64; ; )
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>, iommu@lists.linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Cousson Benoit <b-cousson@ti.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
References: <1316948337-7924-1-git-send-email-ohad@wizery.com> <201109271346.13791.laurent.pinchart@ideasonboard.com> <CAK=WgbZaZTT=PsrvY8QTypuViknCK=APHogZLg5SjSN3_C=odw@mail.gmail.com>
In-Reply-To: <CAK=WgbZaZTT=PsrvY8QTypuViknCK=APHogZLg5SjSN3_C=odw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111091017.41947.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Wednesday 09 November 2011 09:50:30 Ohad Ben-Cohen wrote:
> On Tue, Sep 27, 2011 at 2:46 PM, Laurent Pinchart wrote:
> > On Sunday 25 September 2011 12:58:57 Ohad Ben-Cohen wrote:
> >> Eliminate the public omap_find_iommu_device() method, and don't
> >> expect clients to provide the omap_iommu handle anymore.
> >> 
> >> Instead, OMAP's iommu driver should now utilize dev_archdata's private
> >> iommu extension to be able to access the required iommu information.
> >> 
> >> Update omap3isp appropriately.
> >> 
> >> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> >> Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Tony Lindgren <tony@atomide.com>
> > 
> > For the OMAP3 ISP driver,
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Thanks !
> 
> Can you please also ack the 4th patch in this series (that's the part
> the makes this fifth patch possible):
> 
> https://lkml.org/lkml/2011/9/25/46

Sure. Done.

> I could then ask Tony to Ack it so we could merge this via the iommu tree.

-- 
Regards,

Laurent Pinchart
