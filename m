Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2ISL0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:26:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:64445 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab2ISL0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="194483563"
Date: Wed, 19 Sep 2012 13:26:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] mfd: update on 88pm860x and max8925
Message-ID: <20120919112614.GE8138@sortiz-mobl>
References: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347855552-26213-1-git-send-email-haojian.zhuang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Haojian,

On Mon, Sep 17, 2012 at 12:19:03PM +0800, Haojian Zhuang wrote:
> 1. Updates the patch of max8925 of building issue.
> 2. Include Jett's PREG regulator patch.
> 3. Support DT in 88pm860x.

I applied the 5 first patches.
For the regulator one, I'd like to get Mark's ACK as well.

Patch #6 did not apply cleanly.
Patch #7 needs some fixes and documentation addition.
Patch #8 needs Dmitry's ACK

And I can take patch #9 once #7 is in.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
