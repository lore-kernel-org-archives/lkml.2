Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2DBVxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 17:53:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40888 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2DBVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 17:53:50 -0400
Date: Mon, 2 Apr 2012 22:53:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clkdev: Implement managed clk_get()
Message-ID: <20120402215341.GL24211@n2100.arm.linux.org.uk>
References: <1333403385-24133-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333403385-24133-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 10:49:45PM +0100, Mark Brown wrote:
> Allow clk API users to simplify their cleanup paths by providing a
> managed version of clk_get() and clk_put().
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Much better, thanks.  One minor comment...

> ---
>  Documentation/driver-model/devres.txt |    3 ++
>  drivers/clk/clkdev.c                  |   45 +++++++++++++++++++++++++++++++++
>  include/linux/clk.h                   |   32 +++++++++++++++++++++++
>  3 files changed, 80 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> index 2a596a4..3a10848 100644
> --- a/Documentation/driver-model/devres.txt
> +++ b/Documentation/driver-model/devres.txt
> @@ -276,3 +276,6 @@ REGULATOR
>    devm_regulator_get()
>    devm_regulator_put()
>    devm_regulator_bulk_get()
> +
> +CLOCK
> +  devm_clk_get()

devm_clk_put() ?
