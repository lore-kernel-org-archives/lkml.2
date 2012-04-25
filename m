Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2DYJrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:47:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:29024 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757162Ab2DYJrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:47:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133580737"
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4F97C709.2060807@nvidia.com>
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>
	 <1334920487.31825.98.camel@vkoul-udesk3> <4F9153AF.7020901@nvidia.com>
	 <1335170491.31825.104.camel@vkoul-udesk3> <4F95483F.5020005@nvidia.com>
	 <20120423130659.GA22186@n2100.arm.linux.org.uk>
	 <4F95567E.3090605@nvidia.com>  <4F97BD67.1050300@nvidia.com>
	 <1335346425.31825.118.camel@vkoul-udesk3>  <4F97C709.2060807@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 15:13:48 +0530
Message-ID: <1335347028.31825.122.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 15:12 +0530, Laxman Dewangan wrote:
> On Wednesday 25 April 2012 03:03 PM, Vinod Koul wrote:
> > On Wed, 2012-04-25 at 14:31 +0530, Laxman Dewangan wrote:
> >> I had a  communication with Russell on another change thread and
> >> understand that some more work need to be done in virt_chan to support
> >> cyclic one.
> >>
> >> I want to have the cyclic dma support in my driver so I want to go on
> >> following steps:
> >> 1. I will post the patch for tegra dma which will not use the virt_dma
> >> so that my driver will be independent of Russel's change.
> > which driver? A new driver for cyclic support only or on top of
> > Russell's changes?
> 
> I am referring the Nvidia Tegra's APB dma driver. This will be 
> completely new driver based on dmaengine. We have old dma driver under 
> mach-tegra/dma.c which has tegra specific apis. Want to move this driver 
> to generic dmaengine based api.
Okay, lets review the new patchset then :-)


-- 
~Vinod

