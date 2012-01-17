Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2AQJQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:16:11 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:37006 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab2AQJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:16:09 -0500
Message-ID: <4F153C33.5060805@st.com>
Date: Tue, 17 Jan 2012 14:45:31 +0530
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
References: <cover.1326707233.git.viresh.kumar@st.com> <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com> <4F140D25.1000309@st.com> <CACRpkdbY7ZOwY6GR4t+GODYL4yAdH-PXExmwp84R+Gz2W19X7w@mail.gmail.com>
In-Reply-To: <CACRpkdbY7ZOwY6GR4t+GODYL4yAdH-PXExmwp84R+Gz2W19X7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 2:19 PM, Linus Walleij wrote:
> Are you looking for ffs() from <linus/bitops.h>?
> 
> find-first-set (the include boils down to include/asm-generic/bitops/ffs.h
> if you want to check the implementation).

Thanks, but it might not solve the issue. :(
Actually this will retain the first Least Significant Bit (which is 1)
and will mark all other zero. So it will give output 0b10 for 0b110

>>> >> +      * Fix sconfig's burst size according to dw_dmac. We need to convert
>>> >> +      * them as: 1 -> 0, 2 -> 1, 4 -> 2, 8 -> 3, 16 -> 4.

I need above conversion. i.e. finding bit no. of first bit set.

-- 
viresh
