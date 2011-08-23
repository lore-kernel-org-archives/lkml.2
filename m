Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1HWIdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:33:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:34327 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab1HWIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,268,1312182000"; 
   d="scan'208";a="44121710"
Subject: Re: [PATCH] DMA: PL330: add missing header
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Boojin Kim <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
In-Reply-To: <20110823082319.GA19622@n2100.arm.linux.org.uk>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com>
	 <1314081133.22120.19.camel@vkoul-udesk3>
	 <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com>
	 <1314087342.22120.100.camel@vkoul-udesk3>
	 <20110823082319.GA19622@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 14:02:47 +0530
Message-ID: <1314088367.22120.133.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 09:23 +0100, Russell King - ARM Linux wrote:
> On Tue, Aug 23, 2011 at 01:45:42PM +0530, Koul, Vinod wrote:
> > Russell had fixed compilation of pl330 driver, and was supposed to send
> > the fix to Linus as part of his fixes. If thats not done I can send it
> > for next -rc
> 
> That was for amba-pl08x.c, not pl330.c
Okay, thanks.
I will send the patch for dmaengine.h to Linus for next -rc

That will resolve this error as well

-- 
~Vinod

