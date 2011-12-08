Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1LHHud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:50:33 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:35217 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab1LHHuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:50:32 -0500
Message-ID: <4EE06C3C.8080003@st.com>
Date: Thu, 8 Dec 2011 13:20:20 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>, Amit VIRDI <Amit.VIRDI@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: dmaengine/Query: What about scatter/gather for mem to mem transfers.
References: <4EE038BD.7010705@st.com> <1323329870.1641.27.camel@vkoul-udesk3>
In-Reply-To: <1323329870.1641.27.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/8/2011 1:07 PM, Vinod Koul wrote:
> You mean something like:
>        struct dma_async_tx_descriptor *(*device_prep_dma_sg)(
>                 struct dma_chan *chan,
>                 struct scatterlist *dst_sg, unsigned int dst_nents,
>                 struct scatterlist *src_sg, unsigned int src_nents,
>                 unsigned long flags);
> 
> Its already there, you need to implement in your driver :)

Ok. I didn't knew it. :(

-- 
viresh
