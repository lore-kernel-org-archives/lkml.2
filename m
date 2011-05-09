Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1EIGnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:43:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:28203 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1EIGnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:43:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,339,1301900400"; 
   d="scan'208";a="639944906"
Subject: Re: [PATCH V4 3/5] dmaengine/dw_dmac: Divide one sg to many desc,
 if sg len is greater than DWC_MAX_COUNT
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
In-Reply-To: <4DC78ABB.2030800@st.com>
References: <cover.1304596524.git.viresh.kumar@st.com>
	 <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com>
	 <1304918425.32447.20.camel@vkoul-udesk3>  <4DC783A9.5060802@st.com>
	 <1304920041.32447.33.camel@vkoul-udesk3>  <4DC78ABB.2030800@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 11:41:02 +0530
Message-ID: <1304921462.32447.35.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 12:03 +0530, viresh kumar wrote:
> On 05/09/2011 11:17 AM, Koul, Vinod wrote:
> > Ah, then there is another todo for this driver. Move from chan->private
> > to DMA_SLAVE_CONFIG.
> > 
> > struct dma_slave_config has dedicated fields for both source and
> > destination widths, src_addr_width & dst_addr_width please use them...
> > You should pass this structure to device control API as:
> > dmaengine_device_control(
> > 	chan, DMA_SLAVE_CONFIG, (unsigned long)&slave_config);
> 
> As soon as i get some time, will study & implement this.
> For now, please push this patchset (if it looks fine).
> 
rest looks OK. Please fix the patch1.


-- 
~Vinod

