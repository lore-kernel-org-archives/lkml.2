Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab2KPMiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:38:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:13103 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab2KPMiO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:38:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,264,1352102400"; 
   d="scan'208";a="218691545"
Message-ID: <1353069475.11158.356.camel@smile>
Subject: Re: [PATCH 2/2] dw_dmac: make usage of dw_dma_slave optional
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        spear-devel <spear-devel@list.st.com>, linux-kernel@vger.kernel.org
Date: Fri, 16 Nov 2012 14:37:55 +0200
In-Reply-To: <CAKohpokuGtgz6ohBPR9m0rnu0vhsyi7ywBvfWkSGSps5=PnYEA@mail.gmail.com>
References: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1352989248-28913-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=mpzinz4xr4poNtX0Mom65kfptGM047-hu+XDLTS7m2rw@mail.gmail.com>
	 <1352992898.11158.338.camel@smile>
	 <CAKohpo=F1SmD0qCn9ybOOQ9VXWFQ-BY=udPgrWYPa23M2PuU_g@mail.gmail.com>
	 <1352993269.11158.340.camel@smile>
	 <CAKohpokPEuHy_rmjamLWZRu32f56W29Wo06EbWr4C2iqNqzvXQ@mail.gmail.com>
	 <CAHp75VdDD7GwUUqp50YhbMEgX1kixV=3jmN7-QxV6paHcfWq0Q@mail.gmail.com>
	 <CAKohpokuGtgz6ohBPR9m0rnu0vhsyi7ywBvfWkSGSps5=PnYEA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 09:59 +0530, Viresh Kumar wrote: 
> On 15 November 2012 23:28, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
> > On Thu, Nov 15, 2012 at 5:38 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >> On 15 November 2012 20:57, Andy Shevchenko
> >> <andriy.shevchenko@linux.intel.com> wrote:
> >>> Well, the prep_* should assign the value due to changes of check in the
> >>> dwc_descriptor_complete. Otherwise we will potentially skip some
> >>> important piece of code.
> >>
> >> What i meant to say was, set_runtime_config() must have already done this part.
> >
> > On one hand it is true. On the other - *_prep* functions use
> > explicitly passed parameter. I doubt there is a consistency between
> > value in slave config passed via dwc_control and value passed as
> > explicit function parameter.
> 
> I believe it should be consistent.
> 
> @Vinod: Why have we duplicated direction? Once in prep_* and then in
> slave_config?

Documentation and TODO list say that slave_config.direction is kinda
deprecated.

> 
> --
> viresh

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
