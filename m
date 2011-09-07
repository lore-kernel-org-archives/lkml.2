Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1IGSmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:42:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:11808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1IGSmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:42:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,346,1312182000"; 
   d="scan'208";a="50132757"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "viresh.kumar@st.com" <viresh.kumar@st.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "pratyush.anand@st.com" <pratyush.anand@st.com>,
        "rajeev-dlh.kumar@st.com" <rajeev-dlh.kumar@st.com>,
        "bhupesh.sharma@st.com" <bhupesh.sharma@st.com>,
        "shiraz.hashim@st.com" <shiraz.hashim@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vipin.kumar@st.com" <vipin.kumar@st.com>,
        "armando.visconti@st.com" <armando.visconti@st.com>,
        "Amit.VIRDI@st.com" <Amit.VIRDI@st.com>,
        "vipulkumar.samar@st.com" <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "deepak.sikri@st.com" <deepak.sikri@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 8 Sep 2011 00:12:39 +0530
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
Thread-Topic: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
Thread-Index: AcxtjevFZ/ay2rBDQbqtFtKhtpvREQ==
Message-ID: <438BB0150E931F4B9CE701519A4463010871804A4C@bgsmsx502.gar.corp.intel.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
 <5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
 <20110814083618.GE4986@n2100.arm.linux.org.uk>	<4E4CCF7B.8060704@st.com>
 <20110821083306.GA12028@n2100.arm.linux.org.uk>	<4E532B19.6000103@st.com>
 <4E5715CE.2070806@st.com>
 <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com>
 <4E575E75.40603@st.com>  <4E5F594D.10203@st.com>
In-Reply-To: <4E5F594D.10203@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87Ih6HF021902

On Thu, 2011-09-01 at 15:37 +0530, Viresh Kumar wrote:
> On 8/26/2011 2:21 PM, Viresh Kumar wrote:
> > I just wanted to know, whether i need to do any other modification in this patch or not?
> 
> Hello,
> 
> Do i need to update anything in this patch? Or can this be pushed as it is?
> 
I thought Linus W, and Russell had some comments on this. 

--
~Vinod

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
