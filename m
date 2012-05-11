Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2EKFXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 01:23:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:11562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab2EKFXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 01:23:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164795434"
Subject: Re: [PATCH V2] dmaengine: dw_dmac: Add clk_{un}prepare() support
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <85bdff0af2dd4e4a116f638fe29b19956a16604d.1334662785.git.viresh.kumar@st.com>
References: <85bdff0af2dd4e4a116f638fe29b19956a16604d.1334662785.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 10:46:42 +0530
Message-ID: <1336713402.15424.1509.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 17:10 +0530, Viresh Kumar wrote:
> clk_{un}prepare is mandatory for platforms using common clock framework. Since
> this driver is used by SPEAr platform, which supports common clock framework,
> add clk_{un}prepare() support for it.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>

Applied, Thanks
-- 
~Vinod

