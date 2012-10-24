Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab2JXDnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:43:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:54459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:43:49 -0400
Subject: Re: [PATCH 2/5] ARM: tegra: dts: add slink controller dt entry
From: Vinod Koul <vkoul@infradead.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: vinod.koul@intel.com, Laxman Dewangan <ldewangan@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <50817820.6010301@wwwdotorg.org>
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
	 <1350557795-31487-3-git-send-email-ldewangan@nvidia.com>
	 <50808595.8070505@wwwdotorg.org> <5081190D.50200@nvidia.com>
	 <50817820.6010301@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 08:56:29 +0530
Message-ID: <1351049189.5263.13.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 09:56 -0600, Stephen Warren wrote:
> On 10/19/2012 03:10 AM, Laxman Dewangan wrote:
> > On Friday 19 October 2012 04:11 AM, Stephen Warren wrote:
> >> On 10/18/2012 04:56 AM, Laxman Dewangan wrote:
> >>> Add slink controller details in the dts file of
> >>> Tegra20 and Tegra30.
> >>> diff --git a/arch/arm/boot/dts/tegra20.dtsi
> >>> b/arch/arm/boot/dts/tegra20.dtsi
> >>> +    slink@7000d400 {
> >>> +        compatible = "nvidia,tegra20-slink";
> >>> +        reg =<0x7000d400 0x200>;
> >>> +        interrupts =<0 59 0x04>;
> >>> +        nvidia,dma-req-sel =<15>;
> >
> 
> (Oh, you need a space before and after the = in all the lines above)
> 
> >> I thought the common DT DMA bindings were going to be in 3.7, and hence
> >> we could just use them here rather than inventing another custom
> >> property for this purpose?
> >
> > Adding Vinod here.
> > 
> > I looked the dma devicetree bingind document and did not found the
> > generic binding name. Howvere, for arm-pl330.txt, it is explained as ...
> 
> That's not the generic bindings. I guess they didn't get merged then. I
> guess we can continue with custom bindings until they are.
Yes they are in topic topic/dmaengine_dt in my tree. Will be merged once
we sort out slave apis.


-- 
Vinod Koul
Intel Corp.

