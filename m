Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2I0Kjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:39:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:27540 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab2I0Kjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:39:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,495,1344236400"; 
   d="scan'208";a="197867153"
Subject: Re: [PATCHv3] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
In-Reply-To: <1348740388.1648.27.camel@vkoul-udesk3>
References: <CAOh2x=n4ZCsQ1ccqobZF6fz-Kuj_VE-ua5PftAHQkTobA=p+pw@mail.gmail.com>
	 <1348573156-5032-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348740388.1648.27.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Sep 2012 16:03:48 +0530
Message-ID: <1348742028.1648.29.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-27 at 15:36 +0530, Vinod Koul wrote:
> On Tue, 2012-09-25 at 14:39 +0300, Andy Shevchenko wrote:
> > Not all of the controllers support the 64 bit data width. Make it configurable
> > via platform data. The driver will try to get a value from the component
> > parameters, otherwise it will use the platform data.
> > 
> What was this gen against, I can apply this.
> 

%s/can/can't
-- 
~Vinod

