Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2CVFZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 01:25:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52221 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2CVFZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 01:25:05 -0400
Date: Thu, 22 Mar 2012 13:24:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v13] Regulator: Add Anatop regulator driver
Message-ID: <20120322052449.GB2213@S2101-09.ap.freescale.net>
References: <1331692152-9256-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331692152-9256-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 10:29:12AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.
> 
> Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Reviewed-by: Axel Lin <axel.lin@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
>  drivers/regulator/Kconfig            |    8 +
>  drivers/regulator/Makefile           |    1 +
>  drivers/regulator/anatop-regulator.c |  241 ++++++++++++++++++++++++++++++++++
>  3 files changed, 250 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/anatop-regulator.c
> 
I just noticed that the binding document below got lost since v11 of
the series.

  Documentation/devicetree/bindings/regulator/anatop-regulator.txt

It got lost by mistaken or you dropped it for some reason?

-- 
Regards,
Shawn
