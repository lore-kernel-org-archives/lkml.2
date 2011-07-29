Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab1G2N0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:26:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:20202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1G2N0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="31813499"
Subject: Re: [PATCH 13/18] dmaengine/amba-pl08x: Align lli_len to
 max(src.width, dst.width)
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com
In-Reply-To: <afe9e5154d96c0f44c64c411c98b5db75969db6c.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	 <afe9e5154d96c0f44c64c411c98b5db75969db6c.1311936524.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 18:13:47 +0530
Message-ID: <1311943427.1536.551.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> Currently lli_len is aligned to min of two widths, which looks to be incorrect.
> Instead it should be aligned to max of both widths.
hmmm, not sure I follow you...
In previous patch you said

"max_bytes_per_lli = bd.srcbus.buswidth *
PL080_CONTROL_TRANSFER_SIZE_MASK;
This is confirmed by ARM support guys."

So why should lli_len be related to max of both widths?

-- 
~Vinod

