Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1HYOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:06:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:2988 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1HYOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:06:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="42173995"
Subject: Re: [PATCH V3 00/20] dmaengine/amba-pl08x updates
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@st.com>, pratyush.anand@st.com,
        rajeev-dlh.kumar@st.com, linux@arm.linux.org.uk, bhupesh.sharma@st.com,
        armando.visconti@st.com, linux-kernel@vger.kernel.org,
        vipin.kumar@st.com, shiraz.hashim@st.com, amit.virdi@st.com,
        vipulkumar.samar@st.com, viresh.linux@gmail.com, deepak.sikri@st.com,
        dan.j.williams@intel.com, alim.akhtar@gmail.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <CACRpkdY6KW+tv7H==b15xJyeLp9HCqp9ROBhON0A8JnJDUn8Kg@mail.gmail.com>
References: <cover.1312538034.git.viresh.kumar@st.com>
	 <CACRpkdY6KW+tv7H==b15xJyeLp9HCqp9ROBhON0A8JnJDUn8Kg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 19:36:15 +0530
Message-ID: <1314281175.1606.36.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-23 at 10:17 +0200, Linus Walleij wrote:
> On Fri, Aug 5, 2011 at 12:02 PM, Viresh Kumar <viresh.kumar@st.com> wrote:
> 
> > This patchset contains patches for ARM's pl08x DMA controller driver.
> > Main changes introduced by this patchset are:
> > - Formatting fixes
> > - Logical Fixes
> > - Support for Peripheral as flow controller
> > - Support for sg_len to be greater than 1 for slave transfers
> > - Schedule tasklet for error interrupts
> > - remove pl08x_pre_boundary() routine
> > - support for runtime PM
> > - etc
> 
> I've now tested this patchset:
> 
> patch 3/20 fails to apply cleanly, need rebase on top of Russell's
> fix for dma-mapping.h inclusion. It's a trivial fix.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Vinod could you apply all patches except for 16/18 which has some
> discussion going on, so we get some rotation in -next? The rest of
> Viresh:s patches are really nice stuff to have.
> 
> I will test on the PB11MPcore in the next few days.
> 
Thanks, I have applied this patch series to 17/20

-- 
~Vinod

