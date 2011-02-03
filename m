Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1BCAQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:16:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:28132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab1BCAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:16:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,416,1291622400"; 
   d="scan'208";a="383454426"
Date: Thu, 3 Feb 2011 01:16:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Add fast path for WM831x touchscreen
 interrupts
Message-ID: <20110203001613.GG25448@sortiz-mobl>
References: <1296560773-14918-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1296560773-14918-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296560773-14918-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Feb 01, 2011 at 11:46:13AM +0000, Mark Brown wrote:
> The WM831x interrupt controller provides reporting of the touchscreen
> related interrupts in the primary interrupt status register as a
> performance optimisation - use this to avoid reading the secondary
> status registers for those interrupts.
> 
> For code simplicity and to avoid iterating over all interrupts we open
> code for the two affected interrupt sources.
Patch applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
