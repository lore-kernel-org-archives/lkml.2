Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2AKG4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 01:56:39 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:40928 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483Ab2AKG4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:56:38 -0500
Message-ID: <4F0D3277.8040102@st.com>
Date: Wed, 11 Jan 2012 12:25:51 +0530
From: Rajeev kumar <rajeev-dlh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: Deepak SIKRI <deepak.sikri@st.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Mirko GARDI <mirko.gardi@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] dmaengine/dw_dmac: Hibernation support in dw_dmac
References: <1326262989-18608-1-git-send-email-rajeev-dlh.kumar@st.com> <4F0D2B75.7000800@st.com> <4F0D3134.4090209@st.com>
In-Reply-To: <4F0D3134.4090209@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/11/2012 12:20 PM, Viresh KUMAR wrote:
> On 1/11/2012 11:55 AM, Deepak SIKRI wrote:
>>> +	.freeze_noirq = dw_suspend_noirq,
>>> +	.thaw_noirq =	dw_resume_noirq,
>>> +	.restore_noirq = dw_resume_noirq,
>
> You need to add poweroff_noirq too.
>

Yep, will add this in V2

Best Regards
Rajeev
