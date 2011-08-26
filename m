Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HZDlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 23:41:52 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36465 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243Ab1HZDls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 23:41:48 -0400
Message-ID: <4E5715CE.2070806@st.com>
Date: Fri, 26 Aug 2011 09:11:02 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
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
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len greater
 than one for slave transfers
References: <cover.1311936523.git.viresh.kumar@st.com> <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com> <20110814083618.GE4986@n2100.arm.linux.org.uk> <4E4CCF7B.8060704@st.com> <20110821083306.GA12028@n2100.arm.linux.org.uk> <4E532B19.6000103@st.com>
In-Reply-To: <4E532B19.6000103@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2011 9:52 AM, Viresh Kumar wrote:
> On 8/21/2011 2:03 PM, Russell King - ARM Linux wrote:
>>>> I am not sure if i get this completely. In memcpy, we still don't support
>>>> more than one sg. We have created a new member in txd, which keeps track of
>>>> data (addresses, len).
>> Yes, but we shouldn't need to translate it into any kind of scatterlist.
>>
> 
> Ok. I way out is keeping two separate variables in txd, list for slave transfers,
> and pointer to single element for memcpy. And that looks to be even bad to me.
> Why waste memory, for second variable. Or create union of both.
> 
> One more thing, we can actually have scatter gather in memcpy too in future. This will be
> helpful then also. But surely that's something not implemented currently.
> 

Russell/Linus,

Probably this is the only issue left in this patch. (Sorry if i missed some other points)
Please suggest what should i modify here, so that Vinod can go ahead and push pending
patches too.

-- 
viresh
