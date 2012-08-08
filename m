Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2HHQWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:22:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55041 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763Ab2HHQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:22:07 -0400
Date: Wed, 8 Aug 2012 17:22:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 04/11] ARM: ux500: really kill snowball_of_platform_devs
Message-ID: <20120808162200.GB30473@gmail.com>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
 <1344437248-20560-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1344437248-20560-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:47:21PM +0200, Arnd Bergmann wrote:
> Commit fc67a597a "ARM: ux500: Remove temporary snowball_of_platform_devs
> enablement structure" removed the only user of this variable, but did
> not actually remove the array itself.
> 
> Without this patch, building u8500_defconfig results in:
> 
> arch/arm/mach-ux500/board-mop500.c:729:32: warning: 'snowball_of_platform_devs' defined but not used [-Wunused-variable]

I've already sent a patch that does this:

https://lkml.org/lkml/2012/7/31/305

Just waiting on Linus to review the set.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
