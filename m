Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1CELif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:38:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54121 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1CELie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:38:34 -0500
Date: Sat, 5 Mar 2011 11:38:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        amitgoel <amit.goel@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8 resend] dw_dmac: Remove compilation dependency from
	AVR32
Message-ID: <20110305113817.GC27468@n2100.arm.linux.org.uk>
References: <cover.1298889267.git.viresh.kumar@st.com> <d41145ce4d5e3d870f720709f68d5b1dbf34d6a0.1298889267.git.viresh.kumar@st.com> <1299084372.6974.91.camel@vkoul-udesk3> <4D6F0E32.6050505@st.com> <20110303041909.GT244@DLHLAP0379>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303041909.GT244@DLHLAP0379>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 09:49:09AM +0530, Shiraz Hashim wrote:
> On Thu, Mar 03, 2011 at 11:42:42AM +0800, Viresh KUMAR wrote:
> > On 03/02/2011 10:16 PM, Koul, Vinod wrote:
> > > On Mon, 2011-02-28 at 16:11 +0530, Viresh Kumar wrote:
> 
> [...]
> 
> > >>  drivers/dma/Kconfig |    1 -
> > >>  1 files changed, 0 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> > >> index 1c28816..95c7db7 100644
> > >> --- a/drivers/dma/Kconfig
> > >> +++ b/drivers/dma/Kconfig
> > >> @@ -82,7 +82,6 @@ config INTEL_IOP_ADMA
> > >>  
> > >>  config DW_DMAC
> > >>  	tristate "Synopsys DesignWare AHB DMA support"
> > >> -	depends on AVR32
> > > Shouldn't you be adding a corresponding depends on new arch? And since
> > > this supports old arch as well, it should say depends on both...
> > 
> > Why should this driver be dependent on ARM or AVR32? It can be present
> > on any other arch too.. So i thought removing this dependency all together
> > is better.
> 
> There could be a dependency on HAVE_CLK as it uses clock APIs.

If it uses the clk APIs then it should already depend on HAVE_CLK.
