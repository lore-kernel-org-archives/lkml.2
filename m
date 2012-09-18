Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2IRGzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:55:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:62155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2IRGzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:55:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="223365597"
Message-ID: <1347951305.13371.10.camel@smile>
Subject: Re: [PATCH 2/7] dw_dmac: fill optional encoded parameters in
 register structure
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Tue, 18 Sep 2012 09:55:05 +0300
In-Reply-To: <CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-3-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x==Te7MBNrqX-wjaPzso_xTC44rUejMDhs7SW7HJag7j8g@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:09 +0530, viresh kumar wrote:

[snip]

> > +#define dma_raw_readl(addr, name) \
> > +       readl((addr) + offsetof(struct dw_dma_regs, name))
> > +
> > +#define dma_raw_writel(addr, name, val) \
> > +       writel((val), (addr) + offsetof(struct dw_dma_regs, name))
> > +
> 
> But why don't you use earlier defined readl/writel macros:
> dma_readl and dma_writel?
If you look at further patches, namely 3rd, the access to the register
is needed before we allocate memory for the dw_dma structure.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
