Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1IAKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 06:07:54 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:41977 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1IAKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 06:07:52 -0400
Message-ID: <4E5F594D.10203@st.com>
Date: Thu, 1 Sep 2011 15:37:09 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
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
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len greater
 than one for slave transfers
References: <cover.1311936523.git.viresh.kumar@st.com> <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com> <20110814083618.GE4986@n2100.arm.linux.org.uk>	<4E4CCF7B.8060704@st.com> <20110821083306.GA12028@n2100.arm.linux.org.uk>	<4E532B19.6000103@st.com> <4E5715CE.2070806@st.com> <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com> <4E575E75.40603@st.com>
In-Reply-To: <4E575E75.40603@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2011 2:21 PM, Viresh Kumar wrote:
> I just wanted to know, whether i need to do any other modification in this patch or not?

Hello,

Do i need to update anything in this patch? Or can this be pushed as it is?

-- 
viresh
