Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1JNFvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:51:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:39141 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab1JNFvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:51:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="26629863"
Subject: Re: [PATCH 1/3] dmaengine: Allow controller drivers to set channel
 ids
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Dan <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Bhavna YADAV <bhavna.yadav@st.com>
In-Reply-To: <4E96A55F.6050408@st.com>
References: <63faf72913f4f35b0a542c859522e8333e878c95.1316687776.git.viresh.kumar@st.com>
	 <1317200887.1573.1768.camel@vkoul-udesk3>  <4E96A55F.6050408@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 11:13:38 +0530
Message-ID: <1318571018.1546.383.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-13 at 14:16 +0530, Viresh Kumar wrote:
> On 9/28/2011 2:38 PM, Vinod Koul wrote:
> > to dmaengine, this is just a channel representation in sysfs and nothing
> > more. If damc is assuming that this is same as what dmaengine will do
> > then dmac is wrong.
> > 
> > Nevertheless, Dan was okay with changing this representation.
> > Dan I would need your comments/Ack before we discuss this further
> 
> Hi Vinod/Dan,
> 
> Any update/feedback on this?
Since this touches non slave stuff as well, I need Dan to ack it first

-- 
~Vinod

