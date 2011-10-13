Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1JMIqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:46:39 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:58244 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab1JMIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:46:38 -0400
Message-ID: <4E96A55F.6050408@st.com>
Date: Thu, 13 Oct 2011 14:16:23 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>
Subject: Re: [PATCH 1/3] dmaengine: Allow controller drivers to set channel
 ids
References: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com> <1317200887.1573.1768.camel@vkoul-udesk3>
In-Reply-To: <1317200887.1573.1768.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2011 2:38 PM, Vinod Koul wrote:
> to dmaengine, this is just a channel representation in sysfs and nothing
> more. If damc is assuming that this is same as what dmaengine will do
> then dmac is wrong.
> 
> Nevertheless, Dan was okay with changing this representation.
> Dan I would need your comments/Ack before we discuss this further

Hi Vinod/Dan,

Any update/feedback on this?

-- 
viresh
