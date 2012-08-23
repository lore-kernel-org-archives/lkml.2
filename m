Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab2HWCHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 22:07:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54954 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2HWCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 22:07:17 -0400
Date: Thu, 23 Aug 2012 10:07:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: imx: build pm-imx5 code only when PM is enabled
Message-ID: <20120823020746.GA24242@S2101-09.ap.freescale.net>
References: <1345648390-4234-1-git-send-email-arnd@arndb.de>
 <1345648390-4234-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345648390-4234-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 05:13:07PM +0200, Arnd Bergmann wrote:
> This moves the imx5 pm code out of the list of unconditionally
> compiled files for imx5, mirroring what we already do for imx6
> and how it was done before the code was move from mach-mx5 to
> mach-imx in v3.3.
> 
> Without this patch, building with CONFIG_PM disabled results in:
> 
> arch/arm/mach-imx/pm-imx5.c:202:116: error: redefinition of 'imx51_pm_init'
> arch/arm/mach-imx/include/mach-imx/common.h:154:91: note: previous definition of 'imx51_pm_init' was here
> arch/arm/mach-imx/pm-imx5.c:209:116: error: redefinition of 'imx53_pm_init'
> arch/arm/mach-imx/include/mach-imx/common.h:155:91: note: previous definition of 'imx53_pm_init' was here
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: stable@vger.kernel.org

Acked-by: Shawn Guo <shawn.guo@linaro.org>
