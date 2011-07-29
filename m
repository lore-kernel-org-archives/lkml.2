Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab1G2LAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:00:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53057 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab1G2LAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:00:43 -0400
Date: Fri, 29 Jul 2011 12:00:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        bhupesh.sharma@st.com, shiraz.hashim@st.com, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/18] dmaengine/amba-pl08x: Resolve formatting issues
Message-ID: <20110729110013.GF25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <1e5012faf0649e7ed0113960a9ac8302e46f1354.1311936524.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e5012faf0649e7ed0113960a9ac8302e46f1354.1311936524.git.viresh.kumar@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:19:12PM +0530, Viresh Kumar wrote:
> There were few formatting related issues in code. This patch fixes them.
> Fixes include:
> - Remove extra blank lines and spaces

A double space after a full-stop is standard practice for many people.
Please don't reformat that.

> @@ -284,7 +284,7 @@ static void pl08x_terminate_phy_chan(struct pl08x_driver_data *pl08x,
>  	u32 val = readl(ch->base + PL080_CH_CONFIG);
>  
>  	val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
> -	         PL080_CONFIG_TC_IRQ_MASK);
> +			PL080_CONFIG_TC_IRQ_MASK);

This looks worse than the original.

>  
>  	writel(val, ch->base + PL080_CH_CONFIG);
>  
> @@ -380,7 +380,7 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
>   */
>  static struct pl08x_phy_chan *
>  pl08x_get_phy_channel(struct pl08x_driver_data *pl08x,
> -		      struct pl08x_dma_chan *virt_chan)
> +		struct pl08x_dma_chan *virt_chan)

Ditto.
>  {
>  	struct pl08x_phy_chan *ch = NULL;
>  	unsigned long flags;
> @@ -445,7 +445,7 @@ static inline unsigned int pl08x_get_bytes_for_cctl(unsigned int coded)
>  }
>  
>  static inline u32 pl08x_cctl_bits(u32 cctl, u8 srcwidth, u8 dstwidth,
> -				  size_t tsize)
> +		size_t tsize)

Ditto.

And many more of that.

>  	ret = dma_async_device_register(&pl08x->memcpy);
>  	if (ret) {
> -		dev_warn(&pl08x->adev->dev,
> -			"%s failed to register memcpy as an async device - %d\n",
> -			__func__, ret);
> +		dev_warn(&pl08x->adev->dev, "%s failed to register memcpy as an"
> +				" async device - %d\n", __func__, ret);

Definitely not acceptable.  Ignore warnings about wrapping 80 columns for
kernel messages.
