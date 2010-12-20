Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0LTNAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:00:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:16760 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0LTNAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:00:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,202,1291622400"; 
   d="scan'208";a="688906697"
Date: Mon, 20 Dec 2010 14:00:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Arun Murthy <arun.murthy@stericsson.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: Make AB8500_PWM driver depend on U8500 due to
 PWM breakage
Message-ID: <20101220130004.GG11095@sortiz-mobl>
References: <20101220192121.47767525.sfr@canb.auug.org.au>
 <1292848091-29959-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292848091-29959-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Dec 20, 2010 at 12:28:11PM +0000, Mark Brown wrote:
> Since we don't have a PWM API every PWM driver ends up exporting its
> own version and we need to limit the platforms we try to build them on
> in order to avoid multiple definitions. As the AB8500 is normally a
> companion chip for the U8500 CPU depend on that architecture.
> 
> Previously the driver was relying on the AB8500 core only being built
> on U8500 but this did not give us build coverage of any of the other
> functions for the device.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Here's a better way of solving the problem, 
Definitely nicer, yes. Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
