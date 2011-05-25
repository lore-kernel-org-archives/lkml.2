Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab1EYJIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:08:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:25180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1EYJIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:08:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="4458016"
Subject: Re: [PATCH] dmaengine: Add API documentation for slave dma usage
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>
In-Reply-To: <20110524174840.GA4652@n2100.arm.linux.org.uk>
References: <1306238657-30089-1-git-send-email-vinod.koul@intel.com>
	 <20110524174840.GA4652@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 14:04:36 +0530
Message-ID: <1306312476.30236.118.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 18:48 +0100, Russell King - ARM Linux wrote:
> On Tue, May 24, 2011 at 05:34:17PM +0530, Koul, Vinod wrote:
> 
> Is this document aimed at driver writers using the DMA engine slave API,
> or DMA engine writers implemting the DMA engine slave API?  Most of the
> document appears to be aimed at the users of the API except for this
> last paragraph, and so could be confusing to users reading this document.
Thanks for the comments :)

Its aimed at users, but then thought to add the last one as its often
asked and causes confusion, will explicitly state this...

-- 
~Vinod

