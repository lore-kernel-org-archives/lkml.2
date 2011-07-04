Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1GDOT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:19:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:7981 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab1GDOT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="23614478"
Date: Mon, 4 Jul 2011 16:19:54 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Fix off by one in WM831x IRQ code
Message-ID: <20110704141954.GE3021@sortiz-mobl>
References: <1308698588-16988-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308698588-16988-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jun 22, 2011 at 12:23:08AM +0100, Mark Brown wrote:
> From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
> 
> The GPIO IRQs aren't the first IRQs defined, we need to subtract the base
> for the GPIOs as well to use them for array indexes.
Patch applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
