Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2AQOe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:34:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:56524 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab2AQOex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:34:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99556095"
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
From: Vinod Koul <vinod.koul@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ravi Kumar V <kumarrav@codeaurora.org>, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bryanh@codeaurora.org,
        tsoni@qualcomm.com, dan.j.williams@intel.com, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, johlstei@qualcomm.com
In-Reply-To: <1325901569.10425.14.camel@m0nster>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
	 <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org>
	 <1325901569.10425.14.camel@m0nster>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 20:05:35 +0530
Message-ID: <1326810935.1540.162.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 17:59 -0800, Daniel Walker wrote:
> > +
> > +#define FORCED_FLUSH         0
> > +#define GRACEFUL_FLUSH          1
> 
> Could be an enum ..
Along with proper namespace...

-- 
~Vinod

