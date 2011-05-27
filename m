Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1E0HTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 03:19:13 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54626 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997Ab1E0HTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 03:19:11 -0400
X-Sasl-enc: b0L9YvMKsUfttZoO7TI7EFfYHDNDpz0Q0oK3/woBNzok 1306480750
Date: Fri, 27 May 2011 15:18:38 +0800
From: Greg KH <greg@kroah.com>
To: Mike Travis <travis@sgi.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        iommu@lists.linux-foundation.org, Mike Habeck <habeck@sgi.com>,
        stable@kernel.org
Subject: Re: [stable] [PATCH 1/7] Intel pci: Check for identity mapping
 candidate using system dma mask
Message-ID: <20110527071838.GA16217@kroah.com>
References: <20110527013221.231071058@gulag1.americas.sgi.com>
 <20110527013221.405688800@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110527013221.405688800@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 08:32:22PM -0500, Mike Travis wrote:
> 	The identity mapping code appears to make the assumption that
> 	if the devices dma_mask is greater than 32bits the device can
> 	use identity mapping.  But that is not true, take the case 
> 	where we have a 40bit device in a 44bit architecture.  The
> 	device can potentially receive a physical address that it
> 	will truncate and cause incorrect addresses to be used.
> 
> 	Instead check to see if the device's dma_mask is large enough
> 	to address the system's dma_mask.
> 
> From: Chris Wright <chrisw@sous-sol.org>
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Mike Habeck <habeck@sgi.com>
> ---
>  drivers/pci/intel-iommu.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>

I'll not send this out for the other 6 patches that also do not follow
the proper format, as I'm sure you would get bored reading them.

