Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0KKNS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 08:18:28 -0500
Received: from kroah.org ([198.145.64.141]:55781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759Ab0KKNS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:18:27 -0500
Date: Thu, 11 Nov 2010 05:17:56 -0800
From: Greg KH <greg@kroah.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org, Fernando Guzman Lugo <x0095840@ti.com>,
        linux-omap@vger.kernel.org, Rene Sapiens <rene.sapiens@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/02] staging: tidspbridge: 2.6.37-rcX fixes
Message-ID: <20101111131756.GA26064@kroah.com>
References: <1289440225-27221-1-git-send-email-omar.ramirez@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289440225-27221-1-git-send-email-omar.ramirez@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 07:50:23PM -0600, Omar Ramirez Luna wrote:
> Hi Greg,
> 
> Please consider the following patch set for tidspbridge driver in
> staging tree, the following has been tested on an omap3430 based board
> + gst-dsp environment. Many thanks to Felipe Contreras for piling this up,
> as I'm just propagating his patches.
> 
> First two patches:
> 1. omap: dsp: remove shm from normal memory
> 2. staging: tidspbridge: hardcode SCM macros while fix is upstreamed
> 
> Resolve a couple of build breaks due to adaptations for memblock
> and SCM layer.
> 
> (2) Is meant as a temporary fix, until the patches to fix this
>     (currently in review) are upstreamed. [1]
> 
> The rest of the series, is the revert of iommu migration changes. These
> are needed because, without modifications made to iommu module, they do not
> work; these modifications (on iommu code) didn't make it for the previous
> merge window either.
> 
> I will avoid posting the reverts (unless required), they can be found
> (along with the two patches of this series) at:
> 
> git://dev.omapzoom.org/pub/scm/tidspbridge/kernel-dspbridge.git 
> 	tidspbridge-2.6.37-rc1

I've pulled from this tree and pushed it out to the staging-linus branch
to get sent to Linus before .37 is released.

thanks,

greg k-h
