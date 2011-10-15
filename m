Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1JOBPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 21:15:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:3260 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab1JOBP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 21:15:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,349,1315206000"; 
   d="scan'208";a="62797798"
Date: Sat, 15 Oct 2011 03:18:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Enable rbtree cache for wm831x devices
Message-ID: <20111015011848.GD10229@sortiz-mobl>
References: <1318622786-20189-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318622786-20189-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Oct 14, 2011 at 09:06:26PM +0100, Mark Brown wrote:
> Most useful with the regulators where we're doing a lot of read/modify/write
> updates in potentially performance critical paths.  Providing some defaults
> would make this slightly better but this is a win right now.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Samuel, this depends on the regmap code in -next so I'd like to merge
> it via regmap if that's OK with you?
I'm fine with it:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
