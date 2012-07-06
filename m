Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2GFKgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:36:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:28068 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932546Ab2GFKgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="162086882"
Date: Fri, 6 Jul 2012 12:47:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/1] ARM: ux500: Register the AB8500 from DB8500 MFD
Message-ID: <20120706104736.GA15345@sortiz-mobl>
References: <1341567340-5800-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341567340-5800-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Jul 06, 2012 at 10:35:40AM +0100, Lee Jones wrote:
> As the AB8500 is a subordinate MFD device to the DB8500-PRCMU,
> for consistency and a better 1:1 depiction of how the hardware
> is laid out, it is a good idea to register it in the same way
> as we do for the other MFD child devices. In order for us to do
> this successfully we have to pass AB8500's platform data when
> registering the DB8500-PRCMU from platform code.
> 
> Also solves this issue:
> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'
> 
> Reported-by: Linus Walleij <linus.walleij@linaro.org>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500.c       |   27 +++------------------------
>  arch/arm/mach-ux500/cpu-db8500.c         |    7 +++++--
>  arch/arm/mach-ux500/include/mach/setup.h |    3 ++-
>  drivers/mfd/db8500-prcmu.c               |   10 +++++++++-
>  4 files changed, 19 insertions(+), 28 deletions(-)
Patch applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
