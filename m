Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0F3WxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:53:12 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:31257 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab0F3WxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:53:11 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,515,1272844800"; 
   d="scan'208";a="220049660"
From: Tom Lyon <pugs@lyon-about.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Wed, 30 Jun 2010 15:49:32 -0700
User-Agent: KMail/1.9.9
Cc: Alex Williamson <alex.williamson@redhat.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, avi@redhat.com, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <201006301517.55957.pugs@lyon-about.com> <20100630223256.GB25537@redhat.com>
In-Reply-To: <20100630223256.GB25537@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006301549.32953.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010 03:32:56 pm Michael S. Tsirkin wrote:
> On Wed, Jun 30, 2010 at 03:17:55PM -0700, Tom Lyon wrote:
> > Thanks, Alex!
> > Am incorporating...
> 
> I get it there's no chance you'll drop the "virtualization"
> from the driver then?
> 
I think it'll get a whole lot simpler by depending on iommu interrupt remapping,
but  I thinke some of it is still useful.

I am now stuck trying to get access to a system with interrupt remapping.
Turns out my Intel IOMMU doesn't have it.

