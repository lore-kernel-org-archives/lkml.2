Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2AQKUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:20:24 -0500
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:53543 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab2AQKUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:20:20 -0500
Message-ID: <4F154B4E.2010504@st.com>
Date: Tue, 17 Jan 2012 15:49:58 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>, Bhavna YADAV <bhavna.yadav@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Vincenzo FRASCINO <Vincenzo.FRASCINO@st.com>
Subject: Re: [PATCH 8/8] dmaengine/dw_dmac: Add support for DMA_SLAVE_CONFIG
References: <cover.1326707233.git.viresh.kumar@st.com> <7c1e6fd573d5cd348b22f8363c9960fe5efcd658.1326707233.git.viresh.kumar@st.com> <4F140D25.1000309@st.com> <CAJe_ZhfYgz5LEO7VqOJ8Qo+PZWrMNNvdfvCGQWMMq-TrbmL+xw@mail.gmail.com>
In-Reply-To: <CAJe_ZhfYgz5LEO7VqOJ8Qo+PZWrMNNvdfvCGQWMMq-TrbmL+xw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 3:40 PM, Jassi Brar wrote:
> In case at hand since most likely only valid values are power of 2,
> maybe you can do
>     maxburst = ffs(maxburst) - 1

Thanks.

-- 
viresh
