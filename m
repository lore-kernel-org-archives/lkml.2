Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2IQBKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:10:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2IQBKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 21:10:45 -0400
Date: Sun, 16 Sep 2012 18:10:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>, arm@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: ux500: 8500: use hsit_a_2 group for HSI
Message-ID: <20120917011041.GD19186@quad.lixom.net>
References: <1347620075-18022-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347620075-18022-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 12:54:35PM +0200, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@stericsson.com>
> 
> Due to specific constraint, pin HSIT_ACWAKE0_a is
> not driven by HSI block but as a GPIO.
> 
> Cc: arm@kernel.org
> Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ARM SoC maintainers - I'll take this fixup through the pinctrl
> tree if you don't mind.

Sure, you should know best yourself if you're likely to have conflicts with
other updates in this merge window anyway.

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
