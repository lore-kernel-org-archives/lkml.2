Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab1EIGdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:33:54 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57098 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308Ab1EIGdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:33:53 -0400
Message-ID: <4DC78ABB.2030800@st.com>
Date: Mon, 9 May 2011 12:03:31 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH V4 3/5] dmaengine/dw_dmac: Divide one sg to many desc,
 if sg len is greater than DWC_MAX_COUNT
References: <cover.1304596524.git.viresh.kumar@st.com>	 <f3150fa0fb160c70760b95ac72423ebba354f188.1304596524.git.viresh.kumar@st.com>	 <1304918425.32447.20.camel@vkoul-udesk3>  <4DC783A9.5060802@st.com> <1304920041.32447.33.camel@vkoul-udesk3>
In-Reply-To: <1304920041.32447.33.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2011 11:17 AM, Koul, Vinod wrote:
> Ah, then there is another todo for this driver. Move from chan->private
> to DMA_SLAVE_CONFIG.
> 
> struct dma_slave_config has dedicated fields for both source and
> destination widths, src_addr_width & dst_addr_width please use them...
> You should pass this structure to device control API as:
> dmaengine_device_control(
> 	chan, DMA_SLAVE_CONFIG, (unsigned long)&slave_config);

As soon as i get some time, will study & implement this.
For now, please push this patchset (if it looks fine).

--
viresh
