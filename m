Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2EKIh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:37:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:57887 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940Ab2EKIhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:37:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164861778"
Subject: Re: [PATCH 1/3] dmaengine: Use sg_dma_address instead of sg_phys
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Yong Wang <yong.y.wang@intel.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <CACRpkdaZv0ufh1fh9kmeXu0cC9GFWNwyVT6bXJSSWsM3bGSqog@mail.gmail.com>
References: <1335379853-10122-1-git-send-email-lars@metafoo.de>
	 <CACRpkdaZv0ufh1fh9kmeXu0cC9GFWNwyVT6bXJSSWsM3bGSqog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 14:01:10 +0530
Message-ID: <1336725070.15424.1833.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 23:28 +0200, Linus Walleij wrote:
> On Wed, Apr 25, 2012 at 8:50 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> 
> > dmaengine drivers should always use sg_dma_address instead of sg_phys to get the
> > addresses for the transfer from a sg element.
> 
> All three patches look correct to me (cannot test right now though).
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
Thanks applied all 3.

-- 
~Vinod

