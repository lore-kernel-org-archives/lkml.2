Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1LEDJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 22:09:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:8098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab1LEDJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 22:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,296,1320652800"; 
   d="scan'208";a="98559153"
Subject: Re: [PATCH] dmaengine/amba-pl08x: Config ccfg and increment
 phychan_hold if phychan is true
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com, bhavna.yadav@st.com,
        vincenzo.frascino@st.com, mirko.gardi@st.com
In-Reply-To: <fc4d77e6355cc462cfc2e700415cd56b9db816cb.1322551469.git.viresh.kumar@st.com>
References: <fc4d77e6355cc462cfc2e700415cd56b9db816cb.1322551469.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Dec 2011 08:37:20 +0530
Message-ID: <1323054440.30390.53.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 12:56 +0530, Viresh Kumar wrote:
> Currently, if plchan->phychan is true, we return immediately from
> prep_phy_chan(). We must configure txd->ccfg and increment phychan_hold before
> returning. Otherwise, request line number wouldn't be configured in this txd.
> 
> Reported-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Applied, Thanks

-- 
~Vinod

