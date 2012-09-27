Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab2I0OdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:33:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:42679 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab2I0OdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:33:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="197946366"
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
In-Reply-To: <CAHp75VfCYWqic9MbBZrTO-dM+Yfn6P8q33Fb_LMwmg4rYS5N=w@mail.gmail.com>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	 <1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348740388.1648.27.camel@vkoul-udesk3>
	 <CAHp75VfCYWqic9MbBZrTO-dM+Yfn6P8q33Fb_LMwmg4rYS5N=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 19:57:10 +0530
Message-ID: <1348756030.1648.37.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 17:00 +0300, Andy Shevchenko wrote:
> On Thu, Sep 27, 2012 at 1:06 PM, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> > On Tue, 2012-09-25 at 14:39 +0300, Andy Shevchenko wrote:
> >> Not all of the controllers support the 64 bit data width. Make it configurable
> >> via platform data. The driver will try to get a value from the component
> >> parameters, otherwise it will use the platform data.
> >>
> > What was this gen against, I can apply this.
> Just rebased to recent linux-next, no conflicts.
And I dont apply patches against linux-next!! I apply against
slave-dma-next.
> ...
> Applying: dw_dmac: mark dwc_dump_chan_regs as inline
> Applying: dw_dmac: fill optional encoded parameters in register structure
> Applying: dw_dmac: get number of channels from hardware if possible
> Applying: dw_dmac: autoconfigure block_size or use platform data
> Applying: dw_dmac: autoconfigure data_width or get it via platform data
> Applying: dw_dmac: introduce software emulation of LLP transfers
> ...
> 
> Have you kept the order of the patches?
Obviously see my next

The reason for conflict is nature of this patch. It should be split up. 
arch/arm/mach-spear13xx/spear13xx.c |    2 ++
arch/avr32/mach-at32ap/at32ap700x.c |    2 ++

It fails here, send these separately to Arnd.


-- 
~Vinod

