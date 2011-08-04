Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab1HDJ0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:26:18 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55081 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753154Ab1HDJ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:26:08 -0400
Message-ID: <4E3A659A.6080107@st.com>
Date: Thu, 4 Aug 2011 14:55:46 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
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
Subject: Re: [PATCH V2 07/20] dmaengine/amba-pl08x: Changing few prints to
 dev_dbg from dev_info
References: <cover.1312190881.git.viresh.kumar@st.com>	 <5752f0202ff197d548999395d68131053693e4b3.1312190881.git.viresh.kumar@st.com> <1312446527.1539.2.camel@vkoul-udesk3>
In-Reply-To: <1312446527.1539.2.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 01:58 PM, Koul, Vinod wrote:
>> > +		dev_dbg(&adev->dev,
>> >  			 "physical channel %d is %s\n", i,
>> >  			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
>> >  	}
> ahh, this looks ugly, can you pls fix the print to make them look
> better. Single line or fmt string is one line should be ok, arg can be
> moved to second.

Just to check if I understood your suggestion correctly, you want this:

		dev_dbg(&adev->dev, "physical channel %d is %s\n",
			i, pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");

Surely that will be done.

-- 
viresh
