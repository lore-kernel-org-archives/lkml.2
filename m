Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2DFHLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:11:12 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:35927 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab2DFHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:11:10 -0400
Message-ID: <4F7E96B9.9060907@st.com>
Date: Fri, 06 Apr 2012 09:09:45 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, deepak.sikri@st.com,
        shiraz.hashim@st.com, vikas.manocha@st.com
Subject: Re: linux-next: build failure after merge of the final tree (net-next
 tree related)
References: <20120405132515.e61465875407a452c1a6f78e@canb.auug.org.au> <20120404.235933.350585244341009071.davem@davemloft.net>
In-Reply-To: <20120404.235933.350585244341009071.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2012 5:59 AM, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 5 Apr 2012 13:25:15 +1000
> 
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>>
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c: In function 'stmmac_probe_config_dt':
>> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:53:7: error: 'struct plat_stmmacenet_data' has no member named 'pbl'
>>
>> Caused by commit 8327eb65e795 ("stmmac: re-work the internal GMAC DMA
>> platf parameters").  Clearly I am missing something, because I can't see
>> how that patch is correct since nothing ever assigns to the new dma_cfg
>> pointer but it is dereferenced.
>>
>> I have added this patch to make it build today, but it is obviously not
>> correct.
> 
> Sorry Stephen.
> 
> Giuseppe don't submit patches to me that don't even compile.
> 
> Please submit a proper fix to me for this _now_.

Sorry Dave!
I don't know what happened (I believed to test all).
I'm sending you the patches soon!!!

Peppe

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

