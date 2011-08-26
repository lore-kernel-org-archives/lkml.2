Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1HZIEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:04:02 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40034 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1HZID4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <4E5715CE.2070806@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<5d691ab0c4f447c9f324213d8d740ac61d1739a1.1311936524.git.viresh.kumar@st.com>
	<20110814083618.GE4986@n2100.arm.linux.org.uk>
	<4E4CCF7B.8060704@st.com>
	<20110821083306.GA12028@n2100.arm.linux.org.uk>
	<4E532B19.6000103@st.com>
	<4E5715CE.2070806@st.com>
Date: Fri, 26 Aug 2011 10:03:55 +0200
Message-ID: <CACRpkdapSvW=eMSoXTOOA2GyhfBLzq2OuyQcDctPxsnVzvr-4g@mail.gmail.com>
Subject: Re: [PATCH 16/18] dmaengine/amba-pl08x: Add support for sg len
 greater than one for slave transfers
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratyush ANAND <pratyush.anand@st.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 5:41 AM, Viresh Kumar <viresh.kumar@st.com> wrote:

> Probably this is the only issue left in this patch. (Sorry if i missed some other points)
> Please suggest what should i modify here, so that Vinod can go ahead and push pending
> patches too.

Patches are individual for that very reason - so they can be applied one by one.

I already suggested to Vinod to merge the other patches as far as possible,
for certain 1 thru 15 could be merged right off with some minor
manual fixup. Then we can fix this one patch.

Yours,
Linus Walleij
