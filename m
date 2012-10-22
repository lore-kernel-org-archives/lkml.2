Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2JVNGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:06:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56557 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab2JVNGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:06:43 -0400
Date: Mon, 22 Oct 2012 14:05:57 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@linaro.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: Make the generic clock API available by default
Message-ID: <20121022130556.GM21164@n2100.arm.linux.org.uk>
References: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350910970-9095-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 02:02:50PM +0100, Mark Brown wrote:
> @@ -327,6 +328,7 @@ config ARCH_AT91
>  	select ARCH_REQUIRE_GPIOLIB
>  	select CLKDEV_LOOKUP
>  	select HAVE_CLK
> +	select HAVE_CUSTOM_CLK

This is silly.  If you select "HAVE_CUSTOM_CLK" then isn't it true that
"HAVE_CLK" should also be selected?  If so, why not have "HAVE_CUSTOM_CLK"
do that selection and remove it from all these entries?
