Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2AHXRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:17:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:55264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab2AHXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:17:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="54495313"
Date: Mon, 9 Jan 2012 00:23:26 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@liniux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Still check other interrupts if we get a wm831x
 touchscreen IRQ
Message-ID: <20120108232326.GF13679@sortiz-mobl>
References: <1325006410-22147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325006410-22147-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Dec 27, 2011 at 05:20:10PM +0000, Mark Brown wrote:
> It is possible that we will see another interrupt triggering at the same
> time as the touchscreen interrupts so it's still worth checking other
> possible sources. Almost all of the win from the fast path comes from only
> needing to read the primary register and saving the I/O costs.
Thanks, applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
