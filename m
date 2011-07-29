Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab1G2LVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:21:38 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56928 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886Ab1G2LVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:21:37 -0400
Message-ID: <4E3297AD.5010506@st.com>
Date: Fri, 29 Jul 2011 16:51:17 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/18] dmaengine/amba-pl08x: Resolve formatting issues
References: <cover.1311936523.git.viresh.kumar@st.com> <1e5012faf0649e7ed0113960a9ac8302e46f1354.1311936524.git.viresh.kumar@st.com> <20110729110013.GF25640@n2100.arm.linux.org.uk>
In-Reply-To: <20110729110013.GF25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:30 PM, Russell King - ARM Linux wrote:
> On Fri, Jul 29, 2011 at 04:19:12PM +0530, Viresh Kumar wrote:
>> - Remove extra blank lines and spaces
> 
> A double space after a full-stop is standard practice for many people.
> Please don't reformat that.
> 

Ok. I didn't knew it.

>> @@ -284,7 +284,7 @@ static void pl08x_terminate_phy_chan(struct pl08x_driver_data *pl08x,
>>  	u32 val = readl(ch->base + PL080_CH_CONFIG);
>>  
>>  	val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
>> -	         PL080_CONFIG_TC_IRQ_MASK);
>> +			PL080_CONFIG_TC_IRQ_MASK);
> 
> This looks worse than the original.
> 

> 
> And many more of that.
> 

Ok. Should i leave tabs and spaces mixed or just delete one tab in my change.

>>  	ret = dma_async_device_register(&pl08x->memcpy);
>>  	if (ret) {
>> -		dev_warn(&pl08x->adev->dev,
>> -			"%s failed to register memcpy as an async device - %d\n",
>> -			__func__, ret);
>> +		dev_warn(&pl08x->adev->dev, "%s failed to register memcpy as an"
>> +				" async device - %d\n", __func__, ret);
> 
> Definitely not acceptable.  Ignore warnings about wrapping 80 columns for
> kernel messages.

Ok.

-- 
viresh
