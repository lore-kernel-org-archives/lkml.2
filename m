Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2ENU42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:56:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:19278 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2ENU40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:56:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="143046845"
Date: Mon, 14 May 2012 23:05:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: da9052: Fix genirq abuse
Message-ID: <20120514210551.GI12740@sortiz-mobl>
References: <1336932282-31898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336932282-31898-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, May 13, 2012 at 07:04:42PM +0100, Mark Brown wrote:
> Rather than using the pointer passed back by the regmap API (or complaining
> because that wasn't actually being set) the da9052 driver was having some
> fun and games peering through genirq and regmap internals. Fix the driver
> to use the API as expected.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

I'm fine with you merging this one through your regmap tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
