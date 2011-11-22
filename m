Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1KVGUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:20:31 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:42670 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab1KVGUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:20:30 -0500
Message-ID: <4ECB3F1F.9060806@st.com>
Date: Tue, 22 Nov 2011 11:50:15 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
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
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com> <1321935206.1516.217.camel@vkoul-udesk3>
In-Reply-To: <1321935206.1516.217.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 9:43 AM, Vinod Koul wrote:
> On Thu, 2011-11-17 at 16:01 +0530, Viresh Kumar wrote:
>> > In S2R all DMA registers are reset by hardware and thus they are required to be
> When are they reset, whenever you leave channel idle or once you come
> back from suspend?

Whenever we do S2R, many power islands are switched off and so DMAC controller looses
all its power. On resume, all registers are in their reset state.

-- 
viresh
