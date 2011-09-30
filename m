Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1I3GZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:25:04 -0400
Received: from 8bytes.org ([88.198.83.132]:41485 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1I3GZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:25:02 -0400
Date: Fri, 30 Sep 2011 08:24:59 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg KH <greg@kroah.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, iommu@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110930062459.GA1512@8bytes.org>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com> <1316792756-3395-3-git-send-email-joerg.roedel@amd.com> <20110929200526.GC26760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929200526.GC26760@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Thu, Sep 29, 2011 at 01:05:26PM -0700, Greg KH wrote:
> On Fri, Sep 23, 2011 at 05:45:48PM +0200, Joerg Roedel wrote:
> > This is the starting point to make the iommu_ops used for
> > the iommu-api a per-bus-type structure. It is required to
> > easily implement bus-specific setup in the iommu-layer.
> > The first user will be the iommu-group attribute in sysfs.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Ok, this looks good to me now, thanks for all of the revisions.
> 
> Do you want me to take this through my tree, or do you want it to go
> through some other one?

Thanks for all your feedback :) I would prefer to carry this in my tree
so that we can start to modify the IOMMU driver on-top of it. So can I
add your acked-by to this one?

	Joerg

