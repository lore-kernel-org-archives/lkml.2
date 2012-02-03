Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab2BCSCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:02:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:37145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab2BCSCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:02:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="103628770"
Date: Fri, 3 Feb 2012 19:08:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Balaji T K <balajitk@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: twl-core: Don't specify regulator consumers by
 struct device
Message-ID: <20120203180850.GB17584@sortiz-mobl>
References: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328267137-4816-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Feb 03, 2012 at 11:05:37AM +0000, Mark Brown wrote:
> This has been deprecated for considerable time now and support has been
> removed from the regulator API. dev_name should be used instead.
Thanks for the quick fix. I applied this one to my for-next branch as well.


> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> I'll apply this to the regulator tree as it's thrown up issues due to
> the removal of dev from regulator_consumer_supply - please let me know
> if this is an issue, I can back it out easily enough.
When did the regulator API get modified ? During the last merge window, or is
this one something Linus should be pulling ASAP ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
