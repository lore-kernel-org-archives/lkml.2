Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965762Ab2CALl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:41:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:62079 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889Ab2CALl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:41:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131601127"
Date: Thu, 1 Mar 2012 12:48:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Improve performance of later WM1811 revisions
Message-ID: <20120301114859.GK9008@sortiz-mobl>
References: <1330511958-5796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330511958-5796-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Feb 29, 2012 at 10:39:18AM +0000, Mark Brown wrote:
> Apply tunings from earlier silicon revisions to revisions up to D and also
> tweak an additional setting for improved DC servo performance.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> As this applies on top of things queued in regmap (the patches stuff)
> and seems fairly obvious from a framework point of view I've just gone
> ahead and applied it.
Good, thanks. Just in case you want it:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
