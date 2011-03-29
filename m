Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1C2E7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:59:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:56562 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1C2E7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,259,1299484800"; 
   d="scan'208";a="410152971"
Subject: Re: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
From: "Koul, Vinod" <vinod.koul@intel.com>
To: David Brown <davidb@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>,
        "'Daniel Walker'" <dwalker@fifo99.com>, cjb@laptop.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bryanh@codeaurora.org, linux-kernel@vger.kernel.org
In-Reply-To: <8yak4fo16jp.fsf@huya.qualcomm.com>
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
	 <1300454644-11361-2-git-send-email-subhashj@codeaurora.org>
	 <1300885535.6117.15.camel@m0nster> <005601cbe9f5$a5088750$ef1995f0$@org>
	 <8yak4fo16jp.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 10:00:05 +0530
Message-ID: <1301373005.1695.25.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 15:45 -0700, David Brown wrote:
> 
> Currently none of the MSM DMA hardware uses the DMA engine API, and I
> think we need to figure out if we want to move to that at some point.  I
> realize that the hardware (especially SPS BAM) does a lot more than
> regular DMA, this may involve extending DMA engine, which may or may not
> be appropriate.
If its looks sane extension, I am okay with it :)
Can you point out _exactly_ why the MSM DMA H/W can't use DMA engine at
this point of time?

-- 
~Vinod

