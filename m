Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab0LXLhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 06:37:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:45355 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0LXLht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 06:37:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,223,1291622400"; 
   d="scan'208";a="366171369"
Date: Fri, 24 Dec 2010 12:37:45 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Subject: Re: [PATCH v3 4/4] MFD MAX8998/LP3974: Support Charger
Message-ID: <20101224113744.GH27832@sortiz-mobl>
References: <1293094419-24221-1-git-send-email-myungjoo.ham@samsung.com>
 <1293094419-24221-5-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293094419-24221-5-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 05:53:39PM +0900, MyungJoo Ham wrote:
> With the new regulator, "CHARGER", users can control charging
> current and turn on and off the charger. Note that the charger
> specification of LP3974 is different from that of MAX8998.
> 
> driver/power/max8998.c supports power supply APIs for
> 
> 1. "ONLINE" monitors the charger status, which can be
> different from the status "CHARGER"; e.g., users allowed the charger
> to charge, but the MAX8998 chip decided not to do so.
> 
> 2. "PRESENT" monitors the battery status (the existence of the
> battery).
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Same here, I'll wait for Mark or Liam ACKs before taking this patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
