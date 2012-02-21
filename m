Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab2BUKuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:50:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:33956 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab2BUKui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:50:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119616450"
Date: Tue, 21 Feb 2012 11:50:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.3] mfd: Test for jack detection when deciding if wm8994
 should suspend
Message-ID: <20120221105034.GR5387@sortiz-mobl>
References: <1329773552-22271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329773552-22271-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Feb 20, 2012 at 09:32:32PM +0000, Mark Brown wrote:
> The jack detection on WM1811 is often required during system suspend, add
> it as another check when deciding if we should suspend.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Samuel, could you please add this to your for-linus branch?  It's been
> sitting around unloved for some considerable time now...
Sure. For some reason I misunderstood that you already pushed it.
Applied to my for-linus branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
