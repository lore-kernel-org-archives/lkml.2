Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab1I3OFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 10:05:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51911 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758612Ab1I3OFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 10:05:49 -0400
X-Sasl-enc: b6J2bdRgWjKuxnTdhMdV1V4tSGQLiPJCixEhVE1MKg8c 1317391548
Date: Fri, 30 Sep 2011 06:58:16 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110930135816.GD18646@kroah.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-3-git-send-email-joerg.roedel@amd.com>
 <20110929200526.GC26760@kroah.com>
 <20110930062459.GA1512@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930062459.GA1512@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:24:59AM +0200, Joerg Roedel wrote:
> Hi Greg,
> 
> On Thu, Sep 29, 2011 at 01:05:26PM -0700, Greg KH wrote:
> > On Fri, Sep 23, 2011 at 05:45:48PM +0200, Joerg Roedel wrote:
> > > This is the starting point to make the iommu_ops used for
> > > the iommu-api a per-bus-type structure. It is required to
> > > easily implement bus-specific setup in the iommu-layer.
> > > The first user will be the iommu-group attribute in sysfs.
> > > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > Ok, this looks good to me now, thanks for all of the revisions.
> > 
> > Do you want me to take this through my tree, or do you want it to go
> > through some other one?
> 
> Thanks for all your feedback :) I would prefer to carry this in my tree
> so that we can start to modify the IOMMU driver on-top of it. So can I
> add your acked-by to this one?

Yes, please do:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

