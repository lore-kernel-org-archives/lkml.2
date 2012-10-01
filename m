Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab2JAJws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 05:52:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:25538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab2JAJwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 05:52:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,515,1344236400"; 
   d="scan'208";a="228508715"
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
In-Reply-To: <1349082272.13371.163.camel@smile>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	 <1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348740388.1648.27.camel@vkoul-udesk3>
	 <1348742028.1648.29.camel@vkoul-udesk3>  <1349082272.13371.163.camel@smile>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Oct 2012 15:15:51 +0530
Message-ID: <1349084751.1648.39.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 12:04 +0300, Andy Shevchenko wrote:
> On Thu, 2012-09-27 at 16:03 +0530, Vinod Koul wrote: 
> > On Thu, 2012-09-27 at 15:36 +0530, Vinod Koul wrote:
> > > On Tue, 2012-09-25 at 14:39 +0300, Andy Shevchenko wrote:
> > > > Not all of the controllers support the 64 bit data width. Make it configurable
> > > > via platform data. The driver will try to get a value from the component
> > > > parameters, otherwise it will use the platform data.
> > > > 
> > > What was this gen against, I can apply this.
> > %s/can/can't
> Today I got what was happened. I sent an update to one patch of the
> series, but you tried to apply it on top of previous version. It seems I
> was not clear. So, now we have a regression, and I will send a fix soon
> today.
I received a series, and a patch on top and that what I tried to
apply :(
I am okay to revert the whole series now.

Please send me fix by today, merge window has started, I hate to change
stuff now.



-- 
~Vinod

