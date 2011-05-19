Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1ESL5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:57:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:59966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab1ESL5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:57:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,237,1304319600"; 
   d="scan'208";a="922499"
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DD4A8D8.2040109@st.com>
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>
	 <1305561993.28926.73.camel@vkoul-udesk3>	<4DD1F443.1040205@st.com>
	 <1305603818.28926.82.camel@vkoul-udesk3>	<4DD20D89.9020402@st.com>
	 <BANLkTi=zrr4==Uatq3zbdE1K+1_9ELOBZQ@mail.gmail.com>
	 <4DD4A8D8.2040109@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 16:53:58 +0530
Message-ID: <1305804238.28926.302.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 10:51 +0530, viresh kumar wrote:
> On 05/18/2011 05:51 PM, Linus Walleij wrote:
> >> > @Linus: What do you say? Can we get back to module_init() for amba-pl022?
> >> > And subsys_initcall() for DMA.
> > No, but I sent a patch that will make it possible to have both
> > as subsys_init(), check it out, it seems to work for me.
I am okay with this approach...

Linus, though I am still not convinced why st-dma would need to be
arch_init?

> > 
> > Can you test it? (Sorry forgot to add you on CC, title is
> > "[PATCH] dmaengine: move link order".
> 
> That patch looks good to me. So with that maybe this patch will no
> longer be required.
> 

-- 
~Vinod

