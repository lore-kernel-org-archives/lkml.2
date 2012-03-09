Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2CIDpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:45:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35319 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845Ab2CIDph convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:45:37 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
References: <1331200744-5986-1-git-send-email-paul.liu@linaro.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 9 Mar 2012 11:45:15 +0800
Message-ID: <CAF+7xWm4R02eK0a-q-yTF16fm4tGQUf7XUQK8+KtPNhjnzff5A@mail.gmail.com>
Subject: Re: [PATCH v10] Regulator: Add Anatop regulator driver
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -213,6 +213,14 @@ config REGULATOR_PCAP
>         This driver provides support for the voltage regulators of the
>         PCAP2 PMIC.
>
> +config REGULATOR_ANATOP
> +       tristate "Freescale i.MX on-chip ANATOP LDO regulators"
> +       depends on MFD_ANATOP
> +       help
> +         Say y here to support Freescale i.MX on-chip ANATOP LDOs
> +         regulators. It is recommended that this option be
> +         enabled on i.MX6 platform.
> +
>  config REGULATOR_MC13XXX_CORE
>        tristate
>
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index 503bac8..8440871 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -48,5 +48,6 @@ obj-$(CONFIG_REGULATOR_AB8500)        += ab8500.o
>  obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
>  obj-$(CONFIG_REGULATOR_TPS65910) += tps65910-regulator.o
>  obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
> +obj-$(CONFIG_REGULATOR_ANATOP) += anatop-regulator.o
>
>  ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG

Looks like your patch is against Linus' tree.
Currently, we have sorted the Kconfig entries and Makefile entries in
Mark's tree.
The Kconfig entries are sorted by vender name first, then driver name.
The Makefile entries are sorted by by alphabetical order.

Regards,
Axel
