Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab2INDWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:22:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:10138 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab2INDWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:22:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="221880861"
Subject: Re: [PATCH 03/16] ARM: ep93xx: move platform_data definitions
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Dan Williams <djbw@fb.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1347368390-31252-3-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	 <1347368390-31252-1-git-send-email-arnd@arndb.de>
	 <1347368390-31252-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Sep 2012 08:48:20 +0530
Message-ID: <1347592700.1943.20.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 14:59 +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the ep93xx include directories
> 

>  drivers/dma/ep93xx_dma.c                                         |    2 +-
Acked-by: Vinod Koul <vinod.koul@linux.intel.com>




-- 
~Vinod

