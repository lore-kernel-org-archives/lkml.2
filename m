Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1ESFVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 01:21:43 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:38896 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044Ab1ESFVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 01:21:42 -0400
Message-ID: <4DD4A8D8.2040109@st.com>
Date: Thu, 19 May 2011 10:51:28 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dw_dmac: Replace subsys_init() with arch_initcall()
References: <f06f05e982c6182565a7fee1f7d6396cae895133.1305521318.git.viresh.kumar@st.com>	<1305561993.28926.73.camel@vkoul-udesk3>	<4DD1F443.1040205@st.com>	<1305603818.28926.82.camel@vkoul-udesk3>	<4DD20D89.9020402@st.com> <BANLkTi=zrr4==Uatq3zbdE1K+1_9ELOBZQ@mail.gmail.com>
In-Reply-To: <BANLkTi=zrr4==Uatq3zbdE1K+1_9ELOBZQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 05:51 PM, Linus Walleij wrote:
>> > @Linus: What do you say? Can we get back to module_init() for amba-pl022?
>> > And subsys_initcall() for DMA.
> No, but I sent a patch that will make it possible to have both
> as subsys_init(), check it out, it seems to work for me.
> 
> Can you test it? (Sorry forgot to add you on CC, title is
> "[PATCH] dmaengine: move link order".

That patch looks good to me. So with that maybe this patch will no
longer be required.

-- 
viresh
