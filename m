Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2GTGAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 02:00:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:49929 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab2GTGAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 02:00:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181092768"
Subject: Re: [PATCH 0/7 v2] dma: sh: stop using .private
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 11:30:28 +0530
Message-ID: <1342764028.1726.195.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> This patch series supersedes the one from yesterday with the same title. 
> The 4 patches from v1 are all unchanged, v2 just prepends them with 3 more 
> preparatory patches. From the original series description:
> 
> Here's an attempt to convert the shdma driver to a new method, whereby a 
> centrally provided filter function is used and the DMA_SLAVE_CONFIG command 
> is enabled for slave operation. The last patch is an illustration of how 
> this new method shall be used. If this approach is acceptable, I'll also 
> convert the remaining shdma user drivers. This patch series goes on top of 
> my earlier patches to split shdma.c.
Applied thanks.

Fixed one checkpatch issue though!!

ERROR: "(foo*)" should be "(foo *)"
#996: FILE: drivers/dma/sh/shdma-base.c:662:
+		config = (struct dma_slave_config*)arg;

Please *always* run checkpatch on the patches you send

-- 
~Vinod

