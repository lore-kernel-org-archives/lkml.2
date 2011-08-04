Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab1HDNKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:10:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3235 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1HDNKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:10:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6427"; a="107874927"
Date: Thu, 4 Aug 2011 06:10:15 -0700
From: David Brown <davidb@codeaurora.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] of/address: Add of_iomap_nocache
Message-ID: <20110804131015.GA6596@huya.qualcomm.com>
References: <1312454196-31028-1-git-send-email-davidb@codeaurora.org>
 <B148344E-9580-4C9B-A8FD-942A9713291C@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B148344E-9580-4C9B-A8FD-942A9713291C@kernel.crashing.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 07:44:07AM -0500, Kumar Gala wrote:
> 
> On Aug 4, 2011, at 5:36 AM, David Brown wrote:
> 
> > Add uncached mappings from devicetree nodes similar to regular io
> > mappings.
> > 
> > SPARC is coherent, so there this call is the same as regular of_iomap.
> > 
> > +extern void __iomem *of_iomap_nocache(struct device_node *device, int index);
> 
> What about adding an of_iomap_prot() to match ioremap_prot().

It can be done, but I actually have a use for nocache.  We can
probably add the prot version when first needed.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
