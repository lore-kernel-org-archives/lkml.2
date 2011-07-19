Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1GSJJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:09:03 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:51523 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752456Ab1GSJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:09:01 -0400
Message-ID: <4E25499A.9070703@st.com>
Date: Tue, 19 Jul 2011 14:38:42 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [Query]: What should we do in txd->tx_submit() and device_issue_pending()
References: <4E254067.1060408@st.com> <438BB0150E931F4B9CE701519A4463010871D6C2EF@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <438BB0150E931F4B9CE701519A4463010871D6C2EF@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 02:19 PM, Koul, Vinod wrote:
> (pls wrap your email to 80lines, I have reflowed below for readability) 
>> Hi Dan/Vinod,
>>
>> I have one query regarding implementation of few routines in DMA drivers.
>>
>> What the exact purpose of txd->tx_submit() and device_issue_pending() routines?
>>
>> Should tx_submit() always start physical transfer (Obviously, if channel is
>> free)? Or should it just queue requests and then finally a call to
>> device_issue_pending() must start physical transfers?
> (reflowed your email for 80lines)

Sorry!! :(

> tx_submit is not supposed to start the transfer, it is supposed to add the 
> descriptors in dma driver's queue. The issue_pending is supposed to actually 
> start the transfer. The reasons were well articulated is discussion we had 
> when we did the DMA documentation.
> Pls see https://lkml.org/lkml/2011/5/24/530
> 

Thanks.

-- 
viresh
