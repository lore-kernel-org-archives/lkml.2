Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab1CDJ5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:57:47 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:35789 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab1CDJ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:57:46 -0500
Message-ID: <4D70B786.3010509@st.com>
Date: Fri, 4 Mar 2011 15:27:26 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "hans-christian.egtvedt@atmel.com" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH V2 11/13] dw_dmac: Allow src/dst msize & flow controller
 to be configured at runtime
References: <cover.1299146382.git.viresh.kumar@st.com> <426996869f6231ebff1cbfab5c7ee4c89ccc8745.1299146382.git.viresh.kumar@st.com>
In-Reply-To: <426996869f6231ebff1cbfab5c7ee4c89ccc8745.1299146382.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 03:47 PM, Viresh KUMAR wrote:
> From: Viresh KUMAR <viresh.kumar@st.com>
> 
> Msize or Burst Size is peripheral dependent in case of slave_sg transfers, and
> in case of memcpy transfers it is platform dependent. So msize configuration
> must come from platform data.
> 
> Also some peripherals (ex: JPEG), need to be flow controller for dma transfers,
> so this information in case of slave_sg transfers must come from platform data.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/dma/dw_dmac.c      |   10 ++++++----
>  drivers/dma/dw_dmac_regs.h |    1 +
>  include/linux/dw_dmac.h    |   30 ++++++++++++++++++++++++++++++
>  3 files changed, 37 insertions(+), 4 deletions(-)
> 

Sorry, i missed similar changes for dw_dma_cyclic_prep(). Will resend it.

--
viresh
