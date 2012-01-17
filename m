Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2AQKUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:20:14 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51901 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413Ab2AQKUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:20:12 -0500
Message-ID: <4F154B3D.7050705@st.com>
Date: Tue, 17 Jan 2012 15:49:41 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
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
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>,
        Mirko GARDI <mirko.gardi@st.com>
Subject: Re: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
References: <cover.1326707233.git.viresh.kumar@st.com> <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com> <4F140D25.1000309@st.com> <CACRpkdbY7ZOwY6GR4t+GODYL4yAdH-PXExmwp84R+Gz2W19X7w@mail.gmail.com> <4F153C33.5060805@st.com>
In-Reply-To: <4F153C33.5060805@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 2:45 PM, Viresh Kumar wrote:
> On 1/17/2012 2:19 PM, Linus Walleij wrote:
>> > Are you looking for ffs() from <linus/bitops.h>?
>> > 
>> > find-first-set (the include boils down to include/asm-generic/bitops/ffs.h
>> > if you want to check the implementation).
> Thanks, but it might not solve the issue. :(
> Actually this will retain the first Least Significant Bit (which is 1)
> and will mark all other zero. So it will give output 0b10 for 0b110
> 

Oops!! I didn't looked at fls in the implementation. :(
You are right. This will solve my issue.

-- 
viresh
