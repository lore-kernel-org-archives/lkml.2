Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2JAJEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:04:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:52097 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab2JAJEi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:04:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="199121360"
Message-ID: <1349082272.13371.163.camel@smile>
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Mon, 01 Oct 2012 12:04:32 +0300
In-Reply-To: <1348742028.1648.29.camel@vkoul-udesk3>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	 <1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348740388.1648.27.camel@vkoul-udesk3>
	 <1348742028.1648.29.camel@vkoul-udesk3>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 16:03 +0530, Vinod Koul wrote: 
> On Thu, 2012-09-27 at 15:36 +0530, Vinod Koul wrote:
> > On Tue, 2012-09-25 at 14:39 +0300, Andy Shevchenko wrote:
> > > Not all of the controllers support the 64 bit data width. Make it configurable
> > > via platform data. The driver will try to get a value from the component
> > > parameters, otherwise it will use the platform data.
> > > 
> > What was this gen against, I can apply this.
> %s/can/can't
Today I got what was happened. I sent an update to one patch of the
series, but you tried to apply it on top of previous version. It seems I
was not clear. So, now we have a regression, and I will send a fix soon
today.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
