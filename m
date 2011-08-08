Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1HHIQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:16:16 -0400
Received: from linux-sh.org ([111.68.239.195]:51512 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1HHIQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:16:15 -0400
Date: Mon, 8 Aug 2011 17:15:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Barry Song <Baohua.Song@csr.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, workgroup.linux@csr.com
Subject: Re: [PATCH] GPIOLIB: add generic gpio_set_pull API
Message-ID: <20110808081552.GI32513@linux-sh.org>
References: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312780773-23142-1-git-send-email-Baohua.Song@csr.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 10:19:33PM -0700, Barry Song wrote:
> Now there are many different implementations for GPIO pull configuration, for
> example:
> s3c_gpio_setpull()
> tegra_pinmux_set_pullupdown()
> chipcHw_setPinPullup()
> gpio_pullup()
> s3c2410_gpio_pullup()
> 
> This patch adds a new generic gpio_set_pull API so that all SoCs can have unified
> codes.
> 
> Signed-off-by: Barry Song <Baohua.Song@csr.com>

For arch/arm/mach-shmobile we also have gpio_pull_up() for board-g4evm.c
and gpio_pull_down() for board-mackerel.c. Both of these would benefit
from this sort of an API addition.
