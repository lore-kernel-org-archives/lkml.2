Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1CQX6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:58:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:21584 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1CQX6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="898467348"
Date: Fri, 18 Mar 2011 00:58:10 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Joe Perches <joe@perches.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH v6 2/2] MAX8997/8966 RTC Driver Initial Release
Message-ID: <20110317235810.GI32172@sortiz-mobl>
References: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
 <1300239551-21285-3-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300239551-21285-3-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Wed, Mar 16, 2011 at 10:39:11AM +0900, MyungJoo Ham wrote:
> This patch adds support for RTC functionality for MAX8997/8966 chips.
> 
> The 16ms delay is somehow required by MAX8997 chips (at least for the
> initial releases) and it can be enabled by .delay in platform_data.
I'll wait for Alessandro's ACK before pushing this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
