Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0LOOlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:41:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34339 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab0LOOlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:41:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66721033"
Subject: Re: [PATCH 2/7] msm: Physical offset for MSM8960
From: Daniel Walker <dwalker@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20101215135508.GB8682@huya.qualcomm.com>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	 <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
	 <4D08BFFC.3020103@ru.mvista.com>  <20101215135508.GB8682@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 06:40:54 -0800
Message-ID: <1292424054.13887.5.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 05:55 -0800, David Brown wrote:
> On Wed, Dec 15, 2010 at 04:17:48PM +0300, Sergei Shtylyov wrote:
> 
> > On 15-12-2010 6:49, Stepan Moskovchenko wrote:
> > 
> > > Add the physical memory offset value for the Qualcomm
> > > MSM8960 chip.
> > 
> > > Signed-off-by: Stepan Moskovchenko<stepanm@codeaurora.org>
> > [...]
> > 
> > > diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
> > > index 070e17d..014bbd3 100644
> > > --- a/arch/arm/mach-msm/include/mach/memory.h
> > > +++ b/arch/arm/mach-msm/include/mach/memory.h
> > > @@ -25,6 +25,8 @@
> > >  #define PHYS_OFFSET		UL(0x00200000)
> > >  #elif defined(CONFIG_ARCH_MSM8X60)
> > >  #define PHYS_OFFSET		UL(0x40200000)
> > > +#elif defined(CONFIG_ARCH_MSM8960)
> > > +#define PHYS_OFFSET		UL(0x40200000)
> > 
> >     Why not:
> > 
> > -#elif defined(CONFIG_ARCH_MSM8X60)
> > +#elif defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)
> 
> I guess it's a matter of style, and what one is trying to emphasize.
> Having each one listed makes it easier to change them individually.
> The file is just a listing of the addresses of each chip, so I don't
> see much reason to try and compact it.

It just shows a deeper issue, that the namespace needs work. There's too
much duplication here vs. 8x60 .. If you look over this whole patchset
it looks very much like 8x60 was just copied over.

Daniel
-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


