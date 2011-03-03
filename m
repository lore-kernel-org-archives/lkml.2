Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1CCETi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 23:19:38 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:45772 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757807Ab1CCETh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 23:19:37 -0500
Date: Thu, 3 Mar 2011 09:49:09 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        amitgoel <amit.goel@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8 resend] dw_dmac: Remove compilation dependency from
 AVR32
Message-ID: <20110303041909.GT244@DLHLAP0379>
References: <cover.1298889267.git.viresh.kumar@st.com>
 <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1298889267.git.viresh.kumar@st.com>
 <1299084372.6974.91.camel@vkoul-udesk3>
 <4D6F0E32.6050505@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D6F0E32.6050505@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 11:42:42AM +0800, Viresh KUMAR wrote:
> On 03/02/2011 10:16 PM, Koul, Vinod wrote:
> > On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:

[...]

> >>  drivers/dma/Kconfig |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> >> index 1c28816..95c7db7 100644
> >> --- a/drivers/dma/Kconfig
> >> +++ b/drivers/dma/Kconfig
> >> @@ -82,7 +82,6 @@ config INTEL_IOP_ADMA
> >>  
> >>  config DW_DMAC
> >>  	tristate "Synopsys DesignWare AHB DMA support"
> >> -	depends on AVR32
> > Shouldn't you be adding a corresponding depends on new arch? And since
> > this supports old arch as well, it should say depends on both...
> 
> Why should this driver be dependent on ARM or AVR32? It can be present
> on any other arch too.. So i thought removing this dependency all together
> is better.

There could be a dependency on HAVE_CLK as it uses clock APIs.

-- 
regards
Shiraz
