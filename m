Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1K1DXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 22:23:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:39039 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab1K1DXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:23:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,580,1315206000"; 
   d="scan'208";a="41572423"
Subject: Re: [PATCH] dmaengine/dw_dmac: Reconfigure interrupt and chan_cfg
 register on resume
From: Vinod Koul <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com,
        shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
        deepak.sikri@st.com, vipulkumar.samar@st.com, amit.virdi@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com
In-Reply-To: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>
References: <69e29c139ba027029e11940c6693e9d50dc21613.1321525673.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 08:50:56 +0530
Message-ID: <1322450456.1516.977.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:01 +0530, Viresh Kumar wrote:
> In S2R all DMA registers are reset by hardware and thus they are
> required to be
> reprogrammed. The channels which aren't reprogrammed are channel
> configuration
> and interrupt enable registers, which are currently programmed at
> chan_alloc
> time.
> 
> This patch creates another routine to initialize a channel. It will
> try to
> initialize channel on every dwc_dostart() call. If channel is already
> initialised then it simply returns, otherwise it configures registers.
> 
> This routine will also initialize registers on wakeup from S2R, as we
> mark
> channels as uninitialized on suspend.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com> 
Applied thanks

-- 
~Vinod

