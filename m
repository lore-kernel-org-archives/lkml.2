Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1G2Mlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:41:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:25529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068Ab1G2Mlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="31795808"
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: linus.walleij@linaro.org, pratyush.anand@st.com, rajeev-dlh.kumar@st.com,
        linux@arm.linux.org.uk, bhupesh.sharma@st.com, shiraz.hashim@st.com,
        linux-kernel@vger.kernel.org, vipin.kumar@st.com,
        armando.visconti@st.com, amit.virdi@st.com, vipulkumar.samar@st.com,
        viresh.linux@gmail.com, deepak.sikri@st.com, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 17:28:32 +0530
Message-ID: <1311940712.1536.523.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
> Hi Linus,
> 
> This patchset contains patches for ARM's pl08x DMA controller driver.
> Main changes introduced by this patchset are:
> - Formatting fixes
> - Logical Fixes
> - Support for Peripheral as flow controller
> - Support for sg_len to be greater than 1 for slave transfers
> - Schedule tasklet for error interrupts
> - remove pl08x_pre_boundary() routine
> - etc
Viresh,

There were some fixes required in your driver for changing submit and
issue_pending behavior, was it this one?

-- 
~Vinod

