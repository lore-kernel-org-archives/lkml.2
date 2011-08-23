Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1HWE4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:56:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:49437 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1HWE4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:56:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,267,1312182000"; 
   d="scan'208";a="43056709"
Subject: Re: [PATCH] dmaengine: at_hdmac: add device tree probe
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E4A9BD8.1040302@atmel.com>
References: <1312549120-22266-1-git-send-email-nicolas.ferre@atmel.com>
	 <20110807040932.GF7667@ponder.secretlab.ca>  <4E4A9BD8.1040302@atmel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 10:25:38 +0530
Message-ID: <1314075338.22120.3.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 18:33 +0200, Nicolas Ferre wrote:
> [..]
> 
> Grant, Vinod,
> 
> Don't you think it would make sense to generalize nr-channels and maybe
> also the capabilities properties for other dmaengine drivers?
> I have seen other dmaengine drivers taking the number of channels from
> platform data so that would make sense.
> It would be new dmaengine device tree properties, but on the other hand,
> I do not know if code can also be centralized for handling of those
> properties... maybe it is better to let drivers deal with them if
> required...
> 
We already having this discussion and how to change capabilities etc to
make thing more easy and transparent, See the approaches taken by Jassi
and Linus W

-- 
~Vinod

