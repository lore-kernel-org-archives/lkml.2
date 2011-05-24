Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab1EXJUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:20:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:54159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab1EXJUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:20:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="484684"
Subject: Re: [PATCH resend] dmaengine/dw_dmac: Update maintainer-ship
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        shiraz.hashim@st.com, armando.visconti@st.com, viresh.linux@gmail.com,
        hskinnemoen@gmail.com
In-Reply-To: <fd5b04cbce5c1051dee3faf0719f6db3ee706e60.1306226016.git.viresh.kumar@st.com>
References: <fd5b04cbce5c1051dee3faf0719f6db3ee706e60.1306226016.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 14:16:55 +0530
Message-ID: <1306226815.28926.322.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 14:04 +0530, Viresh Kumar wrote:
> Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
> are currently maintaining it. After discussing with Vinod, sending this patch to
> update maintainer-ship of dw_dmac.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  MAINTAINERS                |    7 +++++++
>  drivers/dma/dw_dmac.c      |    2 ++
>  drivers/dma/dw_dmac_regs.h |    1 +
>  include/linux/dw_dmac.h    |    1 +
>  4 files changed, 11 insertions(+), 0 deletions(-)
Am okay if Havard is...

-- 
~Vinod

