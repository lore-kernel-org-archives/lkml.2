Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768148Ab2KOPRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:17:38 -0500
Received: from mga03.intel.com ([143.182.124.21]:36130 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992479Ab2KOPRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:17:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,258,1352102400"; 
   d="scan'208";a="218226942"
Message-ID: <1352992647.11158.334.camel@smile>
Subject: Re: [PATCH 1/2] dw_dmac: check direction properly in
 dw_dma_cyclic_prep
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Nov 2012 17:17:27 +0200
In-Reply-To: <CAOh2x=kxxKgMQQW8zvg+Y9F94YoPc5yK9gPY3_+FE2QMhpq6Ug@mail.gmail.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=nQ+y+_+mikxQUvWj1zBFf1qrrFgmqHFLZyHm9WY3=jAQ@mail.gmail.com>
	 <CAOh2x=kxxKgMQQW8zvg+Y9F94YoPc5yK9gPY3_+FE2QMhpq6Ug@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-15 at 20:28 +0530, viresh kumar wrote: 
> On Thu, Nov 15, 2012 at 8:05 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> > On Thu, Nov 15, 2012 at 7:50 PM, Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> >> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> >
> >> +static inline bool is_slave_direction(enum dma_transfer_direction direction)
> >> +{
> >> +       return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
> >> +}
> >
> > I would add this in dmaengine.h and will also include check for DMA_DEV_TO_DEV.
> 
> Also, what about is_slave_xfer() name?

No objections.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
