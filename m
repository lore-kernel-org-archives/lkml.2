Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2HVGch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:32:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:57297 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab2HVGce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:32:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,808,1336374000"; 
   d="scan'208";a="208225891"
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barry Song <baohua.song@csr.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <CAGsJ_4wkyY7VkrgMwGwmFF4kpGiGEtU8Ox46G-yOspAi27Lqgg@mail.gmail.com>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1345608994.1895.73.camel@vkoul-udesk3>
	 <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>
	 <alpine.DEB.2.02.1208220729440.1966@localhost6.localdomain6>
	 <CAGsJ_4wkyY7VkrgMwGwmFF4kpGiGEtU8Ox46G-yOspAi27Lqgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 12:04:35 +0530
Message-ID: <1345617275.1895.83.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 13:41 +0800, Barry Song wrote:
> >>
> >>
> >> the git log "drivers/dma/sirf-dma.c: fix usage of devm functions"
> >> should be fixed.
> >
> >
> > What do you suggest?  The patch is about problems with the use of
> > devm_kzalloc, devm_ioremap, and devm_request_irq.
> 
> i mean the prefix
> 
> dmaengine: sirf: .............
That is the usual way, it helps if you see the notation used by
subsystem by checking patches being sent to subsystem, but it is not a
really big deal, pls take care of this in future.


-- 
~Vinod

