Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab1KWLku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:40:50 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:33891 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab1KWLkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:40:49 -0500
Message-ID: <4ECCDBB1.6090708@st.com>
Date: Wed, 23 Nov 2011 17:10:33 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg
 register on resume
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>  <1321935206.1516.217.camel@vkoul-udesk3>  <4ECB3F1F.9060806@st.com>  <1322045375.1516.249.camel@vkoul-udesk3>  <4ECCD4F4.8080903@st.com> <1322047933.1516.266.camel@vkoul-udesk3>
In-Reply-To: <1322047933.1516.266.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 5:02 PM, Vinod Koul wrote:
>> > 
> okay, why were you writing to registers in alloc in the first place :)
> it should have been in the dostart.
> 
> Okay now i get it, looks fine to me, I will apply it

Thanks.

BTW, any updates about following patchset. I didn't got any replies from Dan
on it:

[PATCH 1/3] dmaengine: Allow controller drivers to set channel ids
[PATCH 2/3] dmaengine/dw_dmac: Set channel id's in controller driver
[PATCH 3/3] dmaengine/dw_dmac: Don't use magic number for total number of channels

-- 
viresh
