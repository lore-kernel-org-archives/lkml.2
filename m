Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1ITIMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 04:12:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:12648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1ITIMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 04:12:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,410,1312182000"; 
   d="scan'208";a="53489504"
Subject: Re: [PATCH 16/18] dmaengine/ambhe rest oa-pl08x: Add support for
 sg len greater than one for slave transfers
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4E783243.5000404@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	 <20110814083618.GE4986@n2100.arm.linux.org.uk> <4E4CCF7B.8060704@st.com>
	 <20110821083306.GA12028@n2100.arm.linux.org.uk> <4E532B19.6000103@st.com>
	 <4E5715CE.2070806@st.com>
	 <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com>
	 <4E575E75.40603@st.com> <4E5F594D.10203@st.com>
	 <438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com>
	 <CAKnu2Mp3Ui7jZS2kjJykjuzcTzJhiAkoaVxZ2+tQX0banGh6mw@mail.gmail.com>
	 <4E683B74.5000701@st.com>
	 <CACRpkdaqTYK5TJL2u+aeOfnzhdtdjxZhyu661eGKrNBOXTUTeA@mail.gmail.com>
	 <1315518873.6638.7.camel@vkoul-mobl4>
	 <1316499574.31295.3.camel@vkoul-udesk3>  <4E783243.5000404@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 13:38:05 +0530
Message-ID: <1316506085.31295.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-20 at 11:57 +0530, Viresh Kumar wrote:
> On 9/20/2011 11:49 AM, Vinod Koul wrote:
> > Applied the remaining two patches for the series to my next
> 
> Probably there were three patches left, 18/20, 19/20, 20/20 in V3 of my patchset.
Looks like I had applied patch 20 earlier...


-- 
~Vinod

