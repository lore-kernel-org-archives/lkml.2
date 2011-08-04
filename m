Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1HDJly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:41:54 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:39098 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796Ab1HDJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:41:50 -0400
Message-ID: <4E3A6949.2050109@st.com>
Date: Thu, 4 Aug 2011 15:11:29 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>
Subject: Re: [PATCH V3 08/20] dmaengine/amba-pl08x: support runtime PM
References: <cover.1312190881.git.viresh.kumar@st.com>	 <cbf7119fa968fa54077729aabf1ecca5d21db629.1312190881.git.viresh.kumar@st.com> <1312447973.1539.24.camel@vkoul-udesk3>
In-Reply-To: <1312447973.1539.24.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 02:22 PM, Koul, Vinod wrote:
> i dont think pm_runtime_put_sync() is the right thing to do here. This
> will call your suspend and return after suspend has been called. This
> will delay your probe completion and have impact on system boot time,
> this is a very wrong approach.
> Please move this to _put, so that suspend will be called asynchronously
> 
> Also while at it why should you require all the _put calls to be _sync
> type?

That was a mistake, and i already fixed this in a reply to Russell's mail
today.

-- 
viresh
