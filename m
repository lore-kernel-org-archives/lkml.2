Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab1ITJpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 05:45:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:29387 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab1ITJpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 05:45:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="50226434"
Subject: Re: [PATCH] dmaengine: delete redundant chan_id and chancnt
 initialization in dma drivers
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Baohua.Song@csr.com>
Cc: linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Piotr Ziecik <kosmo@semihalf.com>,
        Yong Wang <yong.y.wang@intel.com>,
        Jaswinder Singh <jassi.brar@samsung.com>,
        Pelagicore AB <info@pelagicore.com>
In-Reply-To: <1316081190-29777-1-git-send-email-Baohua.Song@csr.com>
References: <1316081190-29777-1-git-send-email-Baohua.Song@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 15:11:42 +0530
Message-ID: <1316511702.31295.5.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 03:06 -0700, Barry Song wrote:
> dma_async_device_register will re-init chan_id and chancnt,
> so whatever chan_id and chancnt are set in drivers, they will
> be re-written by dma_async_device_register.
> 
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Piotr Ziecik <kosmo@semihalf.com>
> Cc: Yong Wang <yong.y.wang@intel.com>
> Cc: Jaswinder Singh <jassi.brar@samsung.com>
> Cc: Pelagicore AB <info@pelagicore.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

Applied, Thanks


-- 
~Vinod

