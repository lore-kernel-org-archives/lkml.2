Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2AGINl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 03:13:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:50425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2AGINk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 03:13:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="95488405"
Subject: Re: [PATCH 1/2] dmaengine: Fix status handling in imx-dma.
From: Vinod Koul <vinod.koul@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: dan.j.williams@intel.com, Javier Martin <javier.martin@vista-silicon.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120106124311.GJ5446@pengutronix.de>
References: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
	 <1325829389.1540.95.camel@vkoul-udesk3>
	 <20120106093752.GH5446@pengutronix.de>
	 <1325848224.1540.102.camel@vkoul-udesk3>
	 <20120106124311.GJ5446@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Jan 2012 13:44:00 +0530
Message-ID: <1325924040.1540.104.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 13:43 +0100, Sascha Hauer wrote:
> On Fri, Jan 06, 2012 at 04:40:24PM +0530, Vinod Koul wrote:
> The transfer is not started in prepare but in imxdmac->desc.tx_submit
> 
Well that's incorrect as well. It should be done in issue_pending

Care to fix this up?

-- 
~Vinod

