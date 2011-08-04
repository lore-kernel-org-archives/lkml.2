Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1HDGQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:16:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:41985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1HDGQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:16:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="35648586"
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case
 of error interrupt
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>, Dan <dan.j.williams@intel.com>
Cc: viresh kumar <viresh.linux@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4E3A342E.5080503@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
	 <1311941799.1536.532.camel@vkoul-udesk3>
	 <CAOh2x==_g+JQzTizgVTdH8Dyg_5+KpyYm+G_Ddu5mO15N6n-tw@mail.gmail.com>
	 <1312431918.1536.559.camel@vkoul-udesk3>  <4E3A342E.5080503@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 11:02:42 +0530
Message-ID: <1312435962.1536.566.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 11:24 +0530, viresh kumar wrote:
> On 08/04/2011 09:55 AM, Koul, Vinod wrote:
> > Yes that's the whole point, today callback mechanism doesn't tell the
> > _status_ of the transfer (which if we need change can be discussed as
> > well), but to counter argue I have never been able to generate the error
> > interrupt, are you able to do on your controller?
> 
> Yes, if we supply unaligned address, with access width as word, then it gives
> error interrupt.
> 
> Regarding your point of updating callback for reporting errors,
> I think it is required and should be a common issue.
Okay till now no one has asked for it. We can add to callback arguments
either a bool to indicate what is the transfer status or usual error
code to also indicate what type of failure.
I would prefer latter, if there is consensus on this, we can go thru
with this approach, Dan your comments?

-- 
~Vinod

