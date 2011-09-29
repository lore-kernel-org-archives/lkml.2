Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1I2ULO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:11:14 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52149 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755715Ab1I2ULL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:11:11 -0400
X-Sasl-enc: LopLpMTm2wzLCai4vEspYS02k4fb9zWJhYopk2oUlhGj 1317327070
Date: Thu, 29 Sep 2011 13:05:26 -0700
From: Greg KH <greg@kroah.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, joro@8bytes.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110929200526.GC26760@kroah.com>
References: <1316792756-3395-1-git-send-email-joerg.roedel@amd.com>
 <1316792756-3395-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316792756-3395-3-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 05:45:48PM +0200, Joerg Roedel wrote:
> This is the starting point to make the iommu_ops used for
> the iommu-api a per-bus-type structure. It is required to
> easily implement bus-specific setup in the iommu-layer.
> The first user will be the iommu-group attribute in sysfs.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Ok, this looks good to me now, thanks for all of the revisions.

Do you want me to take this through my tree, or do you want it to go
through some other one?

thanks,

greg k-h
