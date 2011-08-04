Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1HDJhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:37:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:50132 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1HDJhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:37:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="34307693"
Subject: Re: [PATCH V2 07/20] dmaengine/amba-pl08x: Changing few prints to
 dev_dbg from dev_info
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4E3A659A.6080107@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
	 <5752f0202ff197d548999395d68131053693e4b3.1312190881.git.viresh.kumar@st.com>
	 <1312446527.1539.2.camel@vkoul-udesk3>  <4E3A659A.6080107@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 14:23:40 +0530
Message-ID: <1312448020.1539.25.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 14:55 +0530, viresh kumar wrote:
> On 08/04/2011 01:58 PM, Koul, Vinod wrote:
> >> > +		dev_dbg(&adev->dev,
> >> >  			 "physical channel %d is %s\n", i,
> >> >  			 pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
> >> >  	}
> > ahh, this looks ugly, can you pls fix the print to make them look
> > better. Single line or fmt string is one line should be ok, arg can be
> > moved to second.
> 
> Just to check if I understood your suggestion correctly, you want this:
> 
> 		dev_dbg(&adev->dev, "physical channel %d is %s\n",
> 			i, pl08x_phy_channel_busy(ch) ? "BUSY" : "FREE");
> 
> Surely that will be done.
> 

Much better :)
-- 
~Vinod

