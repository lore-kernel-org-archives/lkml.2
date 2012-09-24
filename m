Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2IXIpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:45:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:57818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab2IXIpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:45:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,474,1344236400"; 
   d="scan'208";a="211800324"
Subject: Re: [PATCH 0/2] dmaengine: Fix compillation issues in
 device_prep_dma_cyclic()
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
References: <20120924133923.130c4db72aa8105cb5647d7a@canb.auug.org.au>
	 <1348473485-5081-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Sep 2012 14:10:09 +0530
Message-ID: <1348476009.1943.187.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 10:58 +0300, Peter Ujfalusi wrote:
> Hello,
> 
> The reason for the breakage is the patch 1 got lost somewhere in the process.
> I also greped the whole tree for device_prep_dma_cyclic() and the second patch
> is the result of that.
> 
> PS: I did build tested the series on ARM (OMAP), x86_32, x86_64 but not for ppc
> for sure.
I though patch 1 was part of the series Mark was supposed to apply.

Anyway both look fine to me so:
Both Acked-By: Vinod Koul <vinod.koul@linux.intel.com>

-- 
~Vinod

