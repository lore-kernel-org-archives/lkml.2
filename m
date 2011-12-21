Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1LUDJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:09:52 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:41605
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484Ab1LUDJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:09:49 -0500
X-SpamScore: -8
X-BigFish: VS-8(zz9371I542M154dM1432Nc8kzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Marek Vasut <marek.vasut@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Thread-Topic: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Thread-Index: AQHMvz054UU1JnMzAU21AJwvxWDckZXlh1IAgAAVDaA=
Date: Wed, 21 Dec 2011 03:09:43 +0000
Message-ID: <7FE21149F4667147B645348EC605788505C4E6@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
 <201112202050.22429.marek.vasut@gmail.com>
In-Reply-To: <201112202050.22429.marek.vasut@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Marek Vasut [mailto:marek.vasut@gmail.com]
> Sent: Wednesday, December 21, 2011 3:50 AM
> To: linux-arm-kernel@lists.infradead.org
> Cc: Dong Aisheng-B29396; linux-kernel@vger.kernel.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de; w.sang@pengutronix.de;
> rob.herring@calxeda.com; grant.likely@secretlab.ca; kernel@pengutronix.de;
> cjb@laptop.org; devicetree-discuss@lists.ozlabs.org; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
> Importance: High
> 
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > The driver contains the initial support for imx53 and imx6q.
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Shawn Guo <shanw.guo@freescale.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> >
> 
> Is this imx or mx6q/mx53 ?
> 
It is a common driver and it is intended to support all imx-based
pinctrl driver in the future.
And it includes initial imx53&imx6q support to show as an example.
Maybe too many things included. :-)

> > ---
> > ChangeLog v2->v3:
> > - binding pinmux mappings via pinctrl core API
> > - follow the dt convention to use dash '-' for property name
> >
> > ChangeLog v1->v2:
> > - add basic binding from device tree
> > ---
> >  .../devicetree/bindings/pinctrl/pinctrl-imx.txt    |   59 +++
> >  drivers/pinctrl/Kconfig                            |   20 +
> >  drivers/pinctrl/Makefile                           |    3 +
> >  drivers/pinctrl/pinctrl-imx-core.c                 |  450
> > ++++++++++++++++++++ drivers/pinctrl/pinctrl-imx-core.h                 |
> >  86 ++++
> >  drivers/pinctrl/pinctrl-imx53.c                    |  443
> > +++++++++++++++++++ drivers/pinctrl/pinctrl-imx6q.c                    |
> > 433 +++++++++++++++++++ 7 files changed, 1494 insertions(+), 0
> > deletions(-)
> >  create mode 100644
> > Documentation/devicetree/bindings/pinctrl/pinctrl-imx.txt create mode
> > 100644 drivers/pinctrl/pinctrl-imx-core.c
> >  create mode 100644 drivers/pinctrl/pinctrl-imx-core.h
> >  create mode 100644 drivers/pinctrl/pinctrl-imx53.c  create mode
> > 100644 drivers/pinctrl/pinctrl-imx6q.c
> >
> > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-imx.txt
> > b/Documentation/devicetree/bindings/pinctrl/pinctrl-imx.txt new file
> > mode
> > 100644
> > index 0000000..e45d745
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-imx.txt
> > @@ -0,0 +1,59 @@
> > +* Freescale IOMUX Controller (IOMUXC) for i.MX
> > +
> > +The IOMUX Controller (IOMUXC), together with the IOMUX, enables the
> > +IC to share one PAD to several functional blocks. The sharing is done
> > +by multiplexing the PAD input/output signals. For each PAD there are
> > +up to
> > +8 muxing options (called ALT modes). Since different modules require
> > +different PAD settings (like pull up, keeper, etc) the IOMUXC
> > +controls also the PAD settings parameters.
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,<chip>-iomuxc"
> > +- reg : Should contain IOMUXC registers location and length
> > +- fsl,pinmux-map: phandle of pinmux mappings. Refer to pinctrl.txt
> > +for
> > +  detailed format.
> > +- child nodes containing pinmux data
> > +  Each child node corresponds to a specific pinmux function and the
> > required +  properties of the pinmux function are:
> > +  - func-name: the name of a specific function
> > +  - grp-name: the name of a group pins correspding to this function
> > +  - grp-pins: the list of pins for the group of grp-name
> > +  - num-pins: the pins number of grp-pins list
> > +  - grp-mux: the corresponding mux mode list for grp-pins.
> > +    Each pin in the grp-pins should have a corresponding mux mode for the
> > +    specific function of func-name.
> > +  - num-numx: the mux number of grp-mux list
> > +
> > +Examples:
> > +
> > +pinmux: imx6q-sabreauto-map {
> > +	map-sd4 {
> > +		map-name = "usdhc4";
> > +		ctrl-dev-name = "20e0000.iomuxc";
> > +		function = "sd4";
> > +		dev-name = "219c000.usdhc";
> > +	};
> > +};
> > +
> > +iomuxc@020e0000 {
> > +	compatible = "fsl,imx6q-iomuxc";
> > +	reg = <0x020e0000 0x4000>;
> > +	fsl,pinmux-map = <&pinmux>;
> > +	pinmux_uart4 {
> > +		func-name = "uart4";
> > +		grp-name = "uart4grp";
> > +		grp-pins = <107 108>;
> > +		num-pins = <2>;
> > +		grp-mux = <4 4>;
> > +		num-mux = <2>;
> > +	};
> > +
> > +	pinmux_sd4 {
> > +		func-name = "sd4";
> > +		grp-name = "sd4grp";
> > +		grp-pins = <170 171 180 181 182 183 184 185 186 187>;
> > +		num-pins = <10>;
> > +		grp-mux = <0 0 1 1 1 1 1 1 1 1>;
> > +		num-mux = <10>;
> > +	};
> > +};
> > diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig index
> > c63c721..f65bf5a 100644
> > --- a/drivers/pinctrl/Kconfig
> > +++ b/drivers/pinctrl/Kconfig
> > @@ -23,6 +23,26 @@ config DEBUG_PINCTRL
> >  	help
> >  	  Say Y here to add some extra checks and diagnostics to PINCTRL calls.
> >
> > +config PINCTRL_IMX
> > +	bool "Freescale IMX core pinctrl driver"
> > +	depends on ARCH_MXC
> > +
> > +config PINCTRL_IMX53
> > +	bool "IMX53 pinctrl driver"
> > +	depends on SOC_IMX53
> > +	select PINMUX
> > +	select PINCTRL_IMX
> > +	help
> > +	  Say Y here to enable the imx53 pinctrl driver
> > +
> > +config PINCTRL_IMX6Q
> > +	bool "IMX6Q pinctrl driver"
> > +	depends on SOC_IMX6Q
> > +	select PINMUX
> > +	select PINCTRL_IMX
> > +	help
> > +	  Say Y here to enable the imx6q pinctrl driver
> > +
> >  config PINMUX_SIRF
> >  	bool "CSR SiRFprimaII pinmux driver"
> >  	depends on ARCH_PRIMA2
> > diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile index
> > c046f78..cf85edc 100644
> > --- a/drivers/pinctrl/Makefile
> > +++ b/drivers/pinctrl/Makefile
> > @@ -5,6 +5,9 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
> >  obj-$(CONFIG_PINCTRL)		+= core.o
> >  obj-$(CONFIG_PINMUX)		+= pinmux.o
> >  obj-$(CONFIG_PINCONF)		+= pinconf.o
> > +obj-$(CONFIG_PINMUX_IMX)	+= pinmux-imx-core.o
> > +obj-$(CONFIG_PINMUX_IMX53)	+= pinmux-imx53.o
> > +obj-$(CONFIG_PINMUX_IMX6Q)	+= pinmux-imx6q.o
> >  obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
> >  obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
> >  obj-$(CONFIG_PINCTRL_COH901)	+= pinctrl-coh901.o
> > diff --git a/drivers/pinctrl/pinctrl-imx-core.c
> > b/drivers/pinctrl/pinctrl-imx-core.c new file mode 100644 index
> > 0000000..5c348ba
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinctrl-imx-core.c
> > @@ -0,0 +1,450 @@
> > +/*
> > + * Core driver for the imx pin controller
> > + *
> > + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> > + * Copyright (C) 2011 Linaro Ltd.
> > + *
> > + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/of_device.h>
> > +#include <linux/io.h>
> > +#include <linux/err.h>
> > +#include <linux/pinctrl/pinctrl.h>
> > +#include <linux/pinctrl/pinmux.h>
> > +#include <linux/pinctrl/machine.h>
> > +#include <linux/slab.h>
> > +
> > +#include "pinctrl-imx-core.h"
> > +
> > +#define DRIVER_NAME "pinmux-imx"
> > +
> > +/**
> > + * @dev: a pointer back to containing device
> > + * @virtbase: the offset to the controller in virtual memory  */
> > +struct imx_pmx {
> > +	struct device *dev;
> > +	struct pinctrl_dev *pctl;
> > +	void __iomem *virtbase;
> > +	struct imx_pinctrl_info *info;
> > +};
> > +
> > +#define IMX_PINCTRL_REG_SIZE 4
> > +#define IMX_PINCTRL_MAX_FUNC 7
> > +
> > +static int imx_list_groups(struct pinctrl_dev *pctldev, unsigned
> > +selector) {
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	if (selector >= info->ngroups)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static const char *imx_get_group_name(struct pinctrl_dev *pctldev,
> > +				       unsigned selector)
> > +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	if (selector >= info->ngroups)
> > +		return NULL;
> > +
> > +	return info->groups[selector].name;
> > +}
> > +
> > +static int imx_get_group_pins(struct pinctrl_dev *pctldev, unsigned
> > selector, +			       const unsigned **pins,
> > +			       unsigned *num_pins)
> > +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	if (selector >= info->ngroups)
> > +		return -EINVAL;
> > +
> > +	*pins = info->groups[selector].pins;
> > +	*num_pins = info->groups[selector].num_pins;
> > +
> > +	return 0;
> > +}
> > +
> > +static void imx_pin_dbg_show(struct pinctrl_dev *pctldev, struct
> > +seq_file
> > *s, +		   unsigned offset)
> > +{
> > +	seq_printf(s, " " DRIVER_NAME);
> > +}
> > +
> > +static struct pinctrl_ops imx_pctrl_ops = {
> > +	.list_groups = imx_list_groups,
> > +	.get_group_name = imx_get_group_name,
> > +	.get_group_pins = imx_get_group_pins,
> > +	.pin_dbg_show = imx_pin_dbg_show,
> > +};
> > +
> > +static int imx_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
> > +			   unsigned group)
> > +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +	const unsigned *pins, *mux;
> > +	unsigned int num_pins, num_mux;
> > +	u32 regval, offset;
> > +	int i;
> > +
> > +	/*
> > +	 * Configure the mux mode for each pin in the group for a specific
> > +	 * function.
> > +	 */
> > +	pins = info->groups[group].pins;
> > +	num_pins = info->groups[group].num_pins;
> > +	mux = info->groups[group].mux_mode;
> > +	num_mux = info->groups[group].num_mux;
> > +
> > +	dev_dbg(ipmx->dev, "function %s group %s\n",
> > +		info->functions[selector].name, info->groups[group].name);
> > +
> > +	if (num_pins != num_mux) {
> > +		dev_err(ipmx->dev, "num_mux is not equal to num_pins\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (i = 0; i < num_pins; i++) {
> > +		if (mux[i] > IMX_PINCTRL_MAX_FUNC)
> > +			dev_err(ipmx->dev, "exceeds the maximum mux
> mode(0x7)\n");
> > +		offset = info->mux_offset + pins[i] * IMX_PINCTRL_REG_SIZE;
> > +		regval = readl(ipmx->virtbase + offset);
> > +		regval &= ~IMX_PINCTRL_MAX_FUNC;
> > +		writel(mux[i] | regval, ipmx->virtbase + offset);
> > +		dev_dbg(ipmx->dev, "write: offset 0x%x val 0x%x\n",
> > +			offset, regval | mux[i]);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void imx_pmx_disable(struct pinctrl_dev *pctldev, unsigned
> > func_selector, +			    unsigned group_selector)
> > +{
> > +	/* nothing to do here */
> > +}
> > +
> > +static int imx_pmx_list_funcs(struct pinctrl_dev *pctldev, unsigned
> > selector) +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	if (selector >= info->nfunctions)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> > +static const char *imx_pmx_get_func_name(struct pinctrl_dev *pctldev,
> > +					  unsigned selector)
> > +{
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	return info->functions[selector].name; }
> > +
> > +static int imx_pmx_get_groups(struct pinctrl_dev *pctldev, unsigned
> > selector, +			       const char * const **groups,
> > +			       unsigned * const num_groups) {
> > +	struct imx_pmx *ipmx = pinctrl_dev_get_drvdata(pctldev);
> > +	struct imx_pinctrl_info *info = ipmx->info;
> > +
> > +	*groups = info->functions[selector].groups;
> > +	*num_groups = info->functions[selector].num_groups;
> > +
> > +	return 0;
> > +}
> > +
> > +static struct pinmux_ops imx_pmx_ops = {
> > +	.list_functions = imx_pmx_list_funcs,
> > +	.get_function_name = imx_pmx_get_func_name,
> > +	.get_function_groups = imx_pmx_get_groups,
> > +	.enable = imx_pmx_enable,
> > +	.disable = imx_pmx_disable,
> > +};
> > +
> > +static struct pinctrl_desc imx_pmx_desc = {
> > +	.name = DRIVER_NAME,
> > +	.pctlops = &imx_pctrl_ops,
> > +	.pmxops = &imx_pmx_ops,
> > +	.owner = THIS_MODULE,
> > +};
> > +
> > +#ifdef CONFIG_OF
> > +static int __devinit imx_pmx_parse_functions(struct device_node *np,
> > +			struct imx_pinctrl_info *info, u32 num) {
> > +	struct imx_pmx_func *function;
> > +	struct imx_pin_group *group;
> > +	int ret, len;
> > +
> > +	dev_dbg(info->dev, "parse function %d\n", num);
> > +
> > +	group = &info->groups[num];
> > +	function = &info->functions[num];
> > +
> > +	/* Initialise group */
> > +	ret = of_property_read_string(np, "grp-name", &group->name);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get grp-name\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = of_property_read_u32(np, "num-pins", &group->num_pins);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get num-pins\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = of_property_read_u32(np, "num-mux", &group->num_mux);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get num-mux\n");
> > +		return ret;
> > +	}
> > +
> > +	if (group->num_pins != group->num_mux)
> > +		return -EINVAL;
> > +
> > +	group->pins = devm_kzalloc(info->dev, group->num_pins *
> > +sizeof(unsigned
> > int), +				GFP_KERNEL);
> > +	group->mux_mode = devm_kzalloc(info->dev, group->num_mux *
> > sizeof(unsigned int), +				GFP_KERNEL);
> > +	if (!group->pins || !group->mux_mode)
> > +		return -ENOMEM;
> > +
> > +	/* sanity check */
> > +	if (of_get_property(np, "grp-pins", &len) &&
> > +		len != group->num_pins * sizeof(unsigned int)) {
> > +		dev_err(info->dev, "wrong pins number?\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (of_get_property(np, "grp-mux", &len) &&
> > +		len != group->num_mux * sizeof(unsigned int)) {
> > +		dev_err(info->dev, "wrong pin mux number?\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = of_property_read_u32_array(np, "grp-pins",
> > +			group->pins, group->num_pins);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get grp-pins\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = of_property_read_u32_array(np, "grp-mux",
> > +			group->mux_mode, group->num_mux);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get grp-mux\n");
> > +		return ret;
> > +	}
> > +
> > +	/* Initialise function */
> > +	ret = of_property_read_string(np, "func-name", &function->name);
> > +	if (ret) {
> > +		dev_err(info->dev, "failed to get func-name\n");
> > +		return ret;
> > +	}
> > +
> > +	function->groups = devm_kzalloc(info->dev, sizeof(char **), GFP_KERNEL);
> > +	function->num_groups = 1;
> > +	function->groups[0] = group->name;
> > +
> > +	dev_dbg(info->dev, "func-name %s grp-name %s num-groups %d\n",
> > +				function->name, function->groups[0],
> > +				function->num_groups);
> > +
> > +	return 0;
> > +}
> > +
> > +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> > +				struct imx_pinctrl_info *info)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct device_node *child = NULL;
> > +	struct device_node *map_np;
> > +	int ret, i;
> > +	u32 nfuncs = 0;
> > +
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	nfuncs = of_get_child_count(np);
> > +	if (nfuncs <= 0) {
> > +		dev_err(&pdev->dev, "no functions defined\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	info->nfunctions = nfuncs;
> > +	info->functions = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct
> > imx_pmx_func), +					GFP_KERNEL);
> > +	if (!info->functions)
> > +		return -ENOMEM;
> > +
> > +	/* DT file only passes one group per one function */
> > +	info->ngroups = nfuncs;
> > +	info->groups = devm_kzalloc(&pdev->dev, nfuncs * sizeof(struct
> > imx_pin_group), +					GFP_KERNEL);
> > +	if (!info->groups)
> > +		return -ENOMEM;
> > +
> > +	child = NULL;
> > +	i = 0;
> > +	for_each_child_of_node(np, child) {
> > +		ret = imx_pmx_parse_functions(child, info, i++);
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "failed to parse function\n");
> > +			return ret;
> > +		}
> > +	}
> > +
> > +	/* parse pinmux map */
> > +	map_np = of_parse_phandle(np, "fsl,pinmux-map", 0);
> > +	if (!map_np) {
> > +		dev_err(&pdev->dev, "failed to parse phandle fsl,pinmux-map\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = pinmux_of_register_mappings(map_np);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "failed to register pinmux mappings\n");
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +#else
> > +static int __devinit imx_pmx_probe_dt(struct platform_device *pdev,
> > +				struct imx_pinctrl_info *info)
> > +{
> > +	return -ENODEV;
> > +}
> > +#endif
> > +
> > +static inline void imx_pmx_desc_init(struct pinctrl_desc *pmx_desc,
> > +				const struct imx_pinctrl_info *info) {
> > +	pmx_desc->pins = info->pins;
> > +	pmx_desc->npins = info->npins;
> > +	pmx_desc->maxpin = info->maxpin;
> > +}
> > +
> > +static const struct of_device_id imx_pmx_dt_ids[] = { #ifdef
> > +CONFIG_PINMUX_IMX6Q
> > +	{ .compatible = "fsl,imx6q-iomuxc", .data = (void *)
> &imx6q_pinctrl_info,
> > }, +#endif
> > +#ifdef CONFIG_PINMUX_IMX53
> > +	{ .compatible = "fsl,imx53-iomuxc", .data = (void *)
> &imx53_pinctrl_info,
> > }, +#endif
> > +	{ /* sentinel */ }
> > +};
> > +MODULE_DEVICE_TABLE(of, imx_pmx_dt_ids);
> > +
> > +static int __init imx_pmx_probe(struct platform_device *pdev) {
> > +	const struct of_device_id *of_id =
> > +			of_match_device(imx_pmx_dt_ids, &pdev->dev);
> > +	struct device *dev = &pdev->dev;
> > +	struct imx_pmx *ipmx;
> > +	struct resource *res;
> > +	struct imx_pinctrl_info *info;
> > +	resource_size_t res_size;
> > +	int ret;
> > +
> > +	info = of_id->data;
> > +	if (!info || !info->pins || !(info->maxpin > info->npins)) {
> > +		dev_err(&pdev->dev, "wrong pinctrl info\n");
> > +		return -EINVAL;
> > +	}
> > +	info->dev = &pdev->dev;
> > +
> > +	/* Create state holders etc for this driver */
> > +	ipmx = devm_kzalloc(&pdev->dev, sizeof(*ipmx), GFP_KERNEL);
> > +	if (!ipmx)
> > +		return -ENOMEM;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -ENOENT;
> > +
> > +	res_size = resource_size(res);
> > +	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
> > +		return -EBUSY;
> > +
> > +	ipmx->virtbase = devm_ioremap_nocache(dev, res->start, res_size);
> > +	if (!ipmx->virtbase)
> > +		return -EBUSY;
> > +
> > +	imx_pmx_desc_init(&imx_pmx_desc, info);
> > +	ret = imx_pmx_probe_dt(pdev, info);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "fail to probe dt properties\n");
> > +		return ret;
> > +	}
> > +
> > +	ipmx->pctl = pinctrl_register(&imx_pmx_desc, &pdev->dev, ipmx);
> > +	if (!ipmx->pctl) {
> > +		dev_err(&pdev->dev, "could not register IMX pinmux driver\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ipmx->info = info;
> > +	ipmx->dev = info->dev;
> > +	platform_set_drvdata(pdev, ipmx);
> > +
> > +	dev_info(&pdev->dev, "initialized IMX pinmux driver\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static int __exit imx_pmx_remove(struct platform_device *pdev) {
> > +	struct imx_pmx *ipmx = platform_get_drvdata(pdev);
> > +
> > +	pinctrl_unregister(ipmx->pctl);
> > +	platform_set_drvdata(pdev, NULL);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver imx_pmx_driver = {
> > +	.driver = {
> > +		.name = DRIVER_NAME,
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = imx_pmx_dt_ids,
> > +	},
> > +	.remove = __exit_p(imx_pmx_remove),
> > +};
> > +
> > +static int __init imx_pmx_init(void)
> > +{
> > +	return platform_driver_probe(&imx_pmx_driver, imx_pmx_probe); }
> > +arch_initcall(imx_pmx_init);
> > +
> > +static void __exit imx_pmx_exit(void) {
> > +	platform_driver_unregister(&imx_pmx_driver);
> > +}
> > +module_exit(imx_pmx_exit);
> > +
> > +MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
> > +MODULE_DESCRIPTION("IMX Pin Control Driver"); MODULE_LICENSE("GPL
> > +v2");
> > diff --git a/drivers/pinctrl/pinctrl-imx-core.h
> > b/drivers/pinctrl/pinctrl-imx-core.h new file mode 100644 index
> > 0000000..df69cd0
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinctrl-imx-core.h
> > @@ -0,0 +1,86 @@
> > +/*
> > + * IMX pinmux core definitions
> > + *
> > + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> > + * Copyright (C) 2011 Linaro Ltd.
> > + *
> > + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#ifndef __DRIVERS_PINCTRL_PINMUX_IMX_H #define
> > +__DRIVERS_PINCTRL_PINMUX_IMX_H
> > +
> > +/* Supported Pinctrl type */
> > +enum imx_pinctrl_type {
> > +	IMX53_PINCTRL,
> > +	IMX6Q_PINCTRL,
> > +};
> > +
> > +/**
> > + * struct imx_pin_group - describes an IMX pin group
> > + * @name: the name of this specific pin group
> > + * @pins: an array of discrete physical pins used in this group, taken
> > + *	from the driver-local pin enumeration space
> > + * @num_pins: the number of pins in this group array, i.e. the number of
> > + *	elements in .pins so we can iterate over that array
> > + * @mux_mode: the mux mode for each pins in this group. The size of this
> > + *	array is the same as pins.
> > + */
> > +struct imx_pin_group {
> > +	const char *name;
> > +	unsigned int *pins;
> > +	unsigned num_pins;
> > +	unsigned int *mux_mode;
> > +	unsigned num_mux;
> > +};
> > +
> > +/**
> > + * struct imx_pmx_func - describes IMX pinmux functions
> > + * @name: the name of this specific function
> > + * @groups: corresponding pin groups
> > + */
> > +struct imx_pmx_func {
> > +	const char *name;
> > +	const char **groups;
> > +	unsigned num_groups;
> > +};
> > +
> > +struct imx_pinctrl_info {
> > +	struct device *dev;
> > +	u32 type;
> > +	const struct pinctrl_pin_desc *pins;
> > +	unsigned int npins;
> > +	unsigned int maxpin;
> > +	struct imx_pin_group *groups;
> > +	unsigned int ngroups;
> > +	struct imx_pmx_func *functions;
> > +	unsigned int nfunctions;
> > +	u32 mux_offset;
> > +};
> > +
> > +#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)
> > +
> > +#define IMX_PIN_GROUP(n, p, m)  \
> > +	{			\
> > +		.name = n,	\
> > +		.pins = p,	\
> > +		.num_pins = ARRAY_SIZE(p),	\
> > +		.mux_mode = m,	\
> > +		.num_mux = ARRAY_SIZE(m),	\
> > +	}
> > +
> > +#define IMX_PMX_FUNC(n, g)  \
> > +	{			\
> > +		.name = n,	\
> > +		.groups = g,	\
> > +		.num_groups = ARRAY_SIZE(g),	\
> > +	}
> > +
> > +extern struct imx_pinctrl_info imx53_pinctrl_info; extern struct
> > +imx_pinctrl_info imx6q_pinctrl_info; #endif /*
> > +__DRIVERS_PINCTRL_PINMUX_IMX_H */
> > diff --git a/drivers/pinctrl/pinctrl-imx53.c
> > b/drivers/pinctrl/pinctrl-imx53.c new file mode 100644 index
> > 0000000..079b25e
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinctrl-imx53.c
> > @@ -0,0 +1,443 @@
> > +/*
> > + * imx53 pinctrl driver based on imx pinmux core
> > + *
> > + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> > + * Copyright (C) 2011 Linaro, Inc.
> > + *
> > + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/err.h>
> > +#include <linux/pinctrl/pinctrl.h>
> > +#include <linux/pinctrl/pinmux.h>
> > +
> > +#include "pinctrl-imx-core.h"
> > +
> > +#define IMX53_IOMUXC_MUX_OFFSET 0x20
> > +#define IMX53_IOMUXC_MAXPIN	(23*23)
> > +
> > +enum imx_imx53_pinctrl_pads {
> > +	MX53_GPIO_19 = 0,
> > +	MX53_KEY_COL0 = 1,
> > +	MX53_KEY_ROW0 = 2,
> > +	MX53_KEY_COL1 = 3,
> > +	MX53_KEY_ROW1 = 4,
> > +	MX53_KEY_COL2 = 5,
> > +	MX53_KEY_ROW2 = 6,
> > +	MX53_KEY_COL3 = 7,
> > +	MX53_KEY_ROW3 = 8,
> > +	MX53_KEY_COL4 = 9,
> > +	MX53_KEY_ROW4 = 10,
> > +	MX53_DI0_DISP_CLK = 11,
> > +	MX53_DI0_PIN15 = 12,
> > +	MX53_DI0_PIN2 = 13,
> > +	MX53_DI0_PIN3 = 14,
> > +	MX53_DI0_PIN4 = 15,
> > +	MX53_DISP0_DAT0 = 16,
> > +	MX53_DISP0_DAT1 = 17,
> > +	MX53_DISP0_DAT2 = 18,
> > +	MX53_DISP0_DAT3 = 19,
> > +	MX53_DISP0_DAT4 = 20,
> > +	MX53_DISP0_DAT5 = 21,
> > +	MX53_DISP0_DAT6 = 22,
> > +	MX53_DISP0_DAT7 = 23,
> > +	MX53_DISP0_DAT8 = 24,
> > +	MX53_DISP0_DAT9 = 25,
> > +	MX53_DISP0_DAT10 = 26,
> > +	MX53_DISP0_DAT11 = 27,
> > +	MX53_DISP0_DAT12 = 28,
> > +	MX53_DISP0_DAT13 = 29,
> > +	MX53_DISP0_DAT14 = 30,
> > +	MX53_DISP0_DAT15 = 31,
> > +	MX53_DISP0_DAT16 = 32,
> > +	MX53_DISP0_DAT17 = 33,
> > +	MX53_DISP0_DAT18 = 34,
> > +	MX53_DISP0_DAT19 = 35,
> > +	MX53_DISP0_DAT20 = 36,
> > +	MX53_DISP0_DAT21 = 37,
> > +	MX53_DISP0_DAT22 = 38,
> > +	MX53_DISP0_DAT23 = 39,
> > +	MX53_CSI0_PIXCLK = 40,
> > +	MX53_CSI0_MCLK = 41,
> > +	MX53_CSI0_DATA_EN = 42,
> > +	MX53_CSI0_VSYNC = 43,
> > +	MX53_CSI0_DAT4 = 44,
> > +	MX53_CSI0_DAT5 = 45,
> > +	MX53_CSI0_DAT6 = 46,
> > +	MX53_CSI0_DAT7 = 47,
> > +	MX53_CSI0_DAT8 = 48,
> > +	MX53_CSI0_DAT9 = 49,
> > +	MX53_CSI0_DAT10 = 50,
> > +	MX53_CSI0_DAT11 = 51,
> > +	MX53_CSI0_DAT12 = 52,
> > +	MX53_CSI0_DAT13 = 53,
> > +	MX53_CSI0_DAT14 = 54,
> > +	MX53_CSI0_DAT15 = 55,
> > +	MX53_CSI0_DAT16 = 56,
> > +	MX53_CSI0_DAT17 = 57,
> > +	MX53_CSI0_DAT18 = 58,
> > +	MX53_CSI0_DAT19 = 59,
> > +	MX53_EIM_A25 = 60,
> > +	MX53_EIM_EB2 = 61,
> > +	MX53_EIM_D16 = 62,
> > +	MX53_EIM_D17 = 63,
> > +	MX53_EIM_D18 = 64,
> > +	MX53_EIM_D19 = 65,
> > +	MX53_EIM_D20 = 66,
> > +	MX53_EIM_D21 = 67,
> > +	MX53_EIM_D22 = 68,
> > +	MX53_EIM_D23 = 69,
> > +	MX53_EIM_EB3 = 70,
> > +	MX53_EIM_D24 = 71,
> > +	MX53_EIM_D25 = 72,
> > +	MX53_EIM_D26 = 73,
> > +	MX53_EIM_D27 = 74,
> > +	MX53_EIM_D28 = 75,
> > +	MX53_EIM_D29 = 76,
> > +	MX53_EIM_D30 = 77,
> > +	MX53_EIM_D31 = 78,
> > +	MX53_EIM_A24 = 79,
> > +	MX53_EIM_A23 = 80,
> > +	MX53_EIM_A22 = 81,
> > +	MX53_EIM_A21 = 82,
> > +	MX53_EIM_A20 = 83,
> > +	MX53_EIM_A19 = 84,
> > +	MX53_EIM_A18 = 85,
> > +	MX53_EIM_A17 = 86,
> > +	MX53_EIM_A16 = 87,
> > +	MX53_EIM_CS0 = 88,
> > +	MX53_EIM_CS1 = 89,
> > +	MX53_EIM_OE = 90,
> > +	MX53_EIM_RW = 91,
> > +	MX53_EIM_LBA = 92,
> > +	MX53_EIM_EB0 = 93,
> > +	MX53_EIM_EB1 = 94,
> > +	MX53_EIM_DA0 = 95,
> > +	MX53_EIM_DA1 = 96,
> > +	MX53_EIM_DA2 = 97,
> > +	MX53_EIM_DA3 = 98,
> > +	MX53_EIM_DA4 = 99,
> > +	MX53_EIM_DA5 = 100,
> > +	MX53_EIM_DA6 = 101,
> > +	MX53_EIM_DA7 = 102,
> > +	MX53_EIM_DA8 = 103,
> > +	MX53_EIM_DA9 = 104,
> > +	MX53_EIM_DA10 = 105,
> > +	MX53_EIM_DA11 = 106,
> > +	MX53_EIM_DA12 = 107,
> > +	MX53_EIM_DA13 = 108,
> > +	MX53_EIM_DA14 = 109,
> > +	MX53_EIM_DA15 = 110,
> > +	MX53_NANDF_WE_B = 111,
> > +	MX53_NANDF_RE_B = 112,
> > +	MX53_EIM_WAIT = 113,
> > +	MX53_EIM_BCLK = 114,
> > +	MX53_LVDS1_TX3_P = 115,
> > +	MX53_LVDS1_TX2_P = 116,
> > +	MX53_LVDS1_CLK_P = 117,
> > +	MX53_LVDS1_TX1_P = 118,
> > +	MX53_LVDS1_TX0_P = 119,
> > +	MX53_LVDS0_TX3_P = 120,
> > +	MX53_LVDS0_CLK_P = 121,
> > +	MX53_LVDS0_TX2_P = 122,
> > +	MX53_LVDS0_TX1_P = 123,
> > +	MX53_LVDS0_TX0_P = 124,
> > +	MX53_GPIO_10 = 125,
> > +	MX53_GPIO_11 = 126,
> > +	MX53_GPIO_12 = 127,
> > +	MX53_GPIO_13 = 128,
> > +	MX53_GPIO_14 = 129,
> > +	MX53_NANDF_CLE = 130,
> > +	MX53_NANDF_ALE = 131,
> > +	MX53_NANDF_WP_B = 132,
> > +	MX53_NANDF_RB0 = 133,
> > +	MX53_NANDF_CS0 = 134,
> > +	MX53_NANDF_CS1 = 135,
> > +	MX53_NANDF_CS2 = 136,
> > +	MX53_NANDF_CS3 = 137,
> > +	MX53_FEC_MDIO = 138,
> > +	MX53_FEC_REF_CLK = 139,
> > +	MX53_FEC_RX_ER = 140,
> > +	MX53_FEC_CRS_DV = 141,
> > +	MX53_FEC_RXD1 = 142,
> > +	MX53_FEC_RXD0 = 143,
> > +	MX53_FEC_TX_EN = 144,
> > +	MX53_FEC_TXD1 = 145,
> > +	MX53_FEC_TXD0 = 146,
> > +	MX53_FEC_MDC = 147,
> > +	MX53_PATA_DIOW = 148,
> > +	MX53_PATA_DMACK = 149,
> > +	MX53_PATA_DMARQ = 150,
> > +	MX53_PATA_BUFFER_EN = 151,
> > +	MX53_PATA_INTRQ = 152,
> > +	MX53_PATA_DIOR = 153,
> > +	MX53_PATA_RESET_B = 154,
> > +	MX53_PATA_IORDY = 155,
> > +	MX53_PATA_DA_0 = 156,
> > +	MX53_PATA_DA_1 = 157,
> > +	MX53_PATA_DA_2 = 158,
> > +	MX53_PATA_CS_0 = 159,
> > +	MX53_PATA_CS_1 = 160,
> > +	MX53_PATA_DATA0 = 161,
> > +	MX53_PATA_DATA1 = 162,
> > +	MX53_PATA_DATA2 = 163,
> > +	MX53_PATA_DATA3 = 164,
> > +	MX53_PATA_DATA4 = 165,
> > +	MX53_PATA_DATA5 = 166,
> > +	MX53_PATA_DATA6 = 167,
> > +	MX53_PATA_DATA7 = 168,
> > +	MX53_PATA_DATA8 = 169,
> > +	MX53_PATA_DATA9 = 170,
> > +	MX53_PATA_DATA10 = 171,
> > +	MX53_PATA_DATA11 = 172,
> > +	MX53_PATA_DATA12 = 173,
> > +	MX53_PATA_DATA13 = 174,
> > +	MX53_PATA_DATA14 = 175,
> > +	MX53_PATA_DATA15 = 176,
> > +	MX53_SD1_DATA0 = 177,
> > +	MX53_SD1_DATA1 = 178,
> > +	MX53_SD1_CMD = 179,
> > +	MX53_SD1_DATA2 = 180,
> > +	MX53_SD1_CLK = 181,
> > +	MX53_SD1_DATA3 = 182,
> > +	MX53_SD2_CLK = 183,
> > +	MX53_SD2_CMD = 184,
> > +	MX53_SD2_DATA3 = 185,
> > +	MX53_SD2_DATA2 = 186,
> > +	MX53_SD2_DATA1 = 187,
> > +	MX53_SD2_DATA0 = 188,
> > +	MX53_GPIO_0 = 189,
> > +	MX53_GPIO_1 = 190,
> > +	MX53_GPIO_9 = 191,
> > +	MX53_GPIO_3 = 192,
> > +	MX53_GPIO_6 = 193,
> > +	MX53_GPIO_2 = 194,
> > +	MX53_GPIO_4 = 195,
> > +	MX53_GPIO_5 = 196,
> > +	MX53_GPIO_7 = 197,
> > +	MX53_GPIO_8 = 198,
> > +	MX53_GPIO_16 = 199,
> > +	MX53_GPIO_17 = 200,
> > +	MX53_GPIO_18 = 201,
> > +};
> > +
> > +/* Pad names for the pinmux subsystem */ static const struct
> > +pinctrl_pin_desc imx53_pinctrl_pads[] = {
> > +	IMX_PINCTRL_PIN(MX53_GPIO_19),
> > +	IMX_PINCTRL_PIN(MX53_KEY_COL0),
> > +	IMX_PINCTRL_PIN(MX53_KEY_ROW0),
> > +	IMX_PINCTRL_PIN(MX53_KEY_COL1),
> > +	IMX_PINCTRL_PIN(MX53_KEY_ROW1),
> > +	IMX_PINCTRL_PIN(MX53_KEY_COL2),
> > +	IMX_PINCTRL_PIN(MX53_KEY_ROW2),
> > +	IMX_PINCTRL_PIN(MX53_KEY_COL3),
> > +	IMX_PINCTRL_PIN(MX53_KEY_ROW3),
> > +	IMX_PINCTRL_PIN(MX53_KEY_COL4),
> > +	IMX_PINCTRL_PIN(MX53_KEY_ROW4),
> > +	IMX_PINCTRL_PIN(MX53_DI0_DISP_CLK),
> > +	IMX_PINCTRL_PIN(MX53_DI0_PIN15),
> > +	IMX_PINCTRL_PIN(MX53_DI0_PIN2),
> > +	IMX_PINCTRL_PIN(MX53_DI0_PIN3),
> > +	IMX_PINCTRL_PIN(MX53_DI0_PIN4),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT0),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT1),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT2),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT3),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT4),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT5),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT6),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT7),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT8),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT9),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT10),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT11),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT12),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT13),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT14),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT15),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT16),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT17),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT18),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT19),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT20),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT21),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT22),
> > +	IMX_PINCTRL_PIN(MX53_DISP0_DAT23),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_PIXCLK),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_MCLK),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DATA_EN),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_VSYNC),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT4),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT5),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT6),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT7),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT8),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT9),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT10),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT11),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT12),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT13),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT14),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT15),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT16),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT17),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT18),
> > +	IMX_PINCTRL_PIN(MX53_CSI0_DAT19),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A25),
> > +	IMX_PINCTRL_PIN(MX53_EIM_EB2),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D16),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D17),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D18),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D19),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D20),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D21),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D22),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D23),
> > +	IMX_PINCTRL_PIN(MX53_EIM_EB3),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D24),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D25),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D26),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D27),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D28),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D29),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D30),
> > +	IMX_PINCTRL_PIN(MX53_EIM_D31),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A24),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A23),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A22),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A21),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A20),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A19),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A18),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A17),
> > +	IMX_PINCTRL_PIN(MX53_EIM_A16),
> > +	IMX_PINCTRL_PIN(MX53_EIM_CS0),
> > +	IMX_PINCTRL_PIN(MX53_EIM_CS1),
> > +	IMX_PINCTRL_PIN(MX53_EIM_OE),
> > +	IMX_PINCTRL_PIN(MX53_EIM_RW),
> > +	IMX_PINCTRL_PIN(MX53_EIM_LBA),
> > +	IMX_PINCTRL_PIN(MX53_EIM_EB0),
> > +	IMX_PINCTRL_PIN(MX53_EIM_EB1),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA0),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA1),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA2),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA3),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA4),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA5),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA6),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA7),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA8),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA9),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA10),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA11),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA12),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA13),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA14),
> > +	IMX_PINCTRL_PIN(MX53_EIM_DA15),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_WE_B),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_RE_B),
> > +	IMX_PINCTRL_PIN(MX53_EIM_WAIT),
> > +	IMX_PINCTRL_PIN(MX53_EIM_BCLK),
> > +	IMX_PINCTRL_PIN(MX53_LVDS1_TX3_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS1_TX2_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS1_CLK_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS1_TX1_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS1_TX0_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS0_TX3_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS0_CLK_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS0_TX2_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS0_TX1_P),
> > +	IMX_PINCTRL_PIN(MX53_LVDS0_TX0_P),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_10),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_11),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_12),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_13),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_14),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_CLE),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_ALE),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_WP_B),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_RB0),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_CS0),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_CS1),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_CS2),
> > +	IMX_PINCTRL_PIN(MX53_NANDF_CS3),
> > +	IMX_PINCTRL_PIN(MX53_FEC_MDIO),
> > +	IMX_PINCTRL_PIN(MX53_FEC_REF_CLK),
> > +	IMX_PINCTRL_PIN(MX53_FEC_RX_ER),
> > +	IMX_PINCTRL_PIN(MX53_FEC_CRS_DV),
> > +	IMX_PINCTRL_PIN(MX53_FEC_RXD1),
> > +	IMX_PINCTRL_PIN(MX53_FEC_RXD0),
> > +	IMX_PINCTRL_PIN(MX53_FEC_TX_EN),
> > +	IMX_PINCTRL_PIN(MX53_FEC_TXD1),
> > +	IMX_PINCTRL_PIN(MX53_FEC_TXD0),
> > +	IMX_PINCTRL_PIN(MX53_FEC_MDC),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DIOW),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DMACK),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DMARQ),
> > +	IMX_PINCTRL_PIN(MX53_PATA_BUFFER_EN),
> > +	IMX_PINCTRL_PIN(MX53_PATA_INTRQ),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DIOR),
> > +	IMX_PINCTRL_PIN(MX53_PATA_RESET_B),
> > +	IMX_PINCTRL_PIN(MX53_PATA_IORDY),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DA_0),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DA_1),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DA_2),
> > +	IMX_PINCTRL_PIN(MX53_PATA_CS_0),
> > +	IMX_PINCTRL_PIN(MX53_PATA_CS_1),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA0),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA1),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA2),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA3),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA4),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA5),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA6),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA7),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA8),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA9),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA10),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA11),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA12),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA13),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA14),
> > +	IMX_PINCTRL_PIN(MX53_PATA_DATA15),
> > +	IMX_PINCTRL_PIN(MX53_SD1_DATA0),
> > +	IMX_PINCTRL_PIN(MX53_SD1_DATA1),
> > +	IMX_PINCTRL_PIN(MX53_SD1_CMD),
> > +	IMX_PINCTRL_PIN(MX53_SD1_DATA2),
> > +	IMX_PINCTRL_PIN(MX53_SD1_CLK),
> > +	IMX_PINCTRL_PIN(MX53_SD1_DATA3),
> > +	IMX_PINCTRL_PIN(MX53_SD2_CLK),
> > +	IMX_PINCTRL_PIN(MX53_SD2_CMD),
> > +	IMX_PINCTRL_PIN(MX53_SD2_DATA3),
> > +	IMX_PINCTRL_PIN(MX53_SD2_DATA2),
> > +	IMX_PINCTRL_PIN(MX53_SD2_DATA1),
> > +	IMX_PINCTRL_PIN(MX53_SD2_DATA0),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_0),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_1),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_9),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_3),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_6),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_2),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_4),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_5),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_7),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_8),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_16),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_17),
> > +	IMX_PINCTRL_PIN(MX53_GPIO_18),
> > +};
> > +
> > +struct imx_pinctrl_info imx53_pinctrl_info = {
> > +	.type = IMX53_PINCTRL,
> > +	.pins = imx53_pinctrl_pads,
> > +	.npins = ARRAY_SIZE(imx53_pinctrl_pads),
> > +	.maxpin = IMX53_IOMUXC_MAXPIN,
> > +	.mux_offset = IMX53_IOMUXC_MUX_OFFSET, };
> > diff --git a/drivers/pinctrl/pinctrl-imx6q.c
> > b/drivers/pinctrl/pinctrl-imx6q.c new file mode 100644 index
> > 0000000..4c0e29f
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinctrl-imx6q.c
> > @@ -0,0 +1,433 @@
> > +/*
> > + * imx6q pinctrl driver based on imx pinmux core
> > + *
> > + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> > + * Copyright (C) 2011 Linaro, Inc.
> > + *
> > + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <linux/err.h>
> > +#include <linux/pinctrl/pinctrl.h>
> > +#include <linux/pinctrl/pinmux.h>
> > +
> > +#include "pinctrl-imx-core.h"
> > +
> > +#define IMX6Q_IOMUXC_MUX_OFSSET	0x4c
> > +#define IMX6Q_IOMUXC_MAXPIN	(25*25)
> > +
> > +enum imx6q_pads {
> > +	MX6Q_SD2_DAT1 = 0,
> > +	MX6Q_SD2_DAT2 = 1,
> > +	MX6Q_SD2_DAT0 = 2,
> > +	MX6Q_RGMII_TXC = 3,
> > +	MX6Q_RGMII_TD0 = 4,
> > +	MX6Q_RGMII_TD1 = 5,
> > +	MX6Q_RGMII_TD2 = 6,
> > +	MX6Q_RGMII_TD3 = 7,
> > +	MX6Q_RGMII_RX_CTL = 8,
> > +	MX6Q_RGMII_RD0 = 9,
> > +	MX6Q_RGMII_TX_CTL = 10,
> > +	MX6Q_RGMII_RD1 = 11,
> > +	MX6Q_RGMII_RD2 = 12,
> > +	MX6Q_RGMII_RD3 = 13,
> > +	MX6Q_RGMII_RXC = 14,
> > +	MX6Q_EIM_A25 = 15,
> > +	MX6Q_EIM_EB2 = 16,
> > +	MX6Q_EIM_D16 = 17,
> > +	MX6Q_EIM_D17 = 18,
> > +	MX6Q_EIM_D18 = 19,
> > +	MX6Q_EIM_D19 = 20,
> > +	MX6Q_EIM_D20 = 21,
> > +	MX6Q_EIM_D21 = 22,
> > +	MX6Q_EIM_D22 = 23,
> > +	MX6Q_EIM_D23 = 24,
> > +	MX6Q_EIM_EB3 = 25,
> > +	MX6Q_EIM_D24 = 26,
> > +	MX6Q_EIM_D25 = 27,
> > +	MX6Q_EIM_D26 = 28,
> > +	MX6Q_EIM_D27 = 29,
> > +	MX6Q_EIM_D28 = 30,
> > +	MX6Q_EIM_D29 = 31,
> > +	MX6Q_EIM_D30 = 32,
> > +	MX6Q_EIM_D31 = 33,
> > +	MX6Q_EIM_A24 = 34,
> > +	MX6Q_EIM_A23 = 35,
> > +	MX6Q_EIM_A22 = 36,
> > +	MX6Q_EIM_A21 = 37,
> > +	MX6Q_EIM_A20 = 38,
> > +	MX6Q_EIM_A19 = 39,
> > +	MX6Q_EIM_A18 = 40,
> > +	MX6Q_EIM_A17 = 41,
> > +	MX6Q_EIM_A16 = 42,
> > +	MX6Q_EIM_CS0 = 43,
> > +	MX6Q_EIM_CS1 = 44,
> > +	MX6Q_EIM_OE = 45,
> > +	MX6Q_EIM_RW = 46,
> > +	MX6Q_EIM_LBA = 47,
> > +	MX6Q_EIM_EB0 = 48,
> > +	MX6Q_EIM_EB1 = 49,
> > +	MX6Q_EIM_DA0 = 50,
> > +	MX6Q_EIM_DA1 = 51,
> > +	MX6Q_EIM_DA2 = 52,
> > +	MX6Q_EIM_DA3 = 53,
> > +	MX6Q_EIM_DA4 = 54,
> > +	MX6Q_EIM_DA5 = 55,
> > +	MX6Q_EIM_DA6 = 56,
> > +	MX6Q_EIM_DA7 = 57,
> > +	MX6Q_EIM_DA8 = 58,
> > +	MX6Q_EIM_DA9 = 59,
> > +	MX6Q_EIM_DA10 = 60,
> > +	MX6Q_EIM_DA11 = 61,
> > +	MX6Q_EIM_DA12 = 62,
> > +	MX6Q_EIM_DA13 = 63,
> > +	MX6Q_EIM_DA14 = 64,
> > +	MX6Q_EIM_DA15 = 65,
> > +	MX6Q_EIM_WAIT = 66,
> > +	MX6Q_EIM_BCLK = 67,
> > +	MX6Q_DI0_DISP_CLK = 68,
> > +	MX6Q_DI0_PIN15 = 69,
> > +	MX6Q_DI0_PIN2 = 70,
> > +	MX6Q_DI0_PIN3 = 71,
> > +	MX6Q_DI0_PIN4 = 72,
> > +	MX6Q_DISP0_DAT0 = 73,
> > +	MX6Q_DISP0_DAT1 = 74,
> > +	MX6Q_DISP0_DAT2 = 75,
> > +	MX6Q_DISP0_DAT3 = 76,
> > +	MX6Q_DISP0_DAT4 = 77,
> > +	MX6Q_DISP0_DAT5 = 78,
> > +	MX6Q_DISP0_DAT6 = 79,
> > +	MX6Q_DISP0_DAT7 = 80,
> > +	MX6Q_DISP0_DAT8 = 81,
> > +	MX6Q_DISP0_DAT9 = 82,
> > +	MX6Q_DISP0_DAT10 = 83,
> > +	MX6Q_DISP0_DAT11 = 84,
> > +	MX6Q_DISP0_DAT12 = 85,
> > +	MX6Q_DISP0_DAT13 = 86,
> > +	MX6Q_DISP0_DAT14 = 87,
> > +	MX6Q_DISP0_DAT15 = 88,
> > +	MX6Q_DISP0_DAT16 = 89,
> > +	MX6Q_DISP0_DAT17 = 90,
> > +	MX6Q_DISP0_DAT18 = 91,
> > +	MX6Q_DISP0_DAT19 = 92,
> > +	MX6Q_DISP0_DAT20 = 93,
> > +	MX6Q_DISP0_DAT21 = 94,
> > +	MX6Q_DISP0_DAT22 = 95,
> > +	MX6Q_DISP0_DAT23 = 96,
> > +	MX6Q_ENET_MDIO = 97,
> > +	MX6Q_ENET_REF_CLK = 98,
> > +	MX6Q_ENET_RX_ER = 99,
> > +	MX6Q_ENET_CRS_DV = 100,
> > +	MX6Q_ENET_RXD1 = 101,
> > +	MX6Q_ENET_RXD0 = 102,
> > +	MX6Q_ENET_TX_EN = 103,
> > +	MX6Q_ENET_TXD1 = 104,
> > +	MX6Q_ENET_TXD0 = 105,
> > +	MX6Q_ENET_MDC = 106,
> > +	MX6Q_KEY_COL0 = 107,
> > +	MX6Q_KEY_ROW0 = 108,
> > +	MX6Q_KEY_COL1 = 109,
> > +	MX6Q_KEY_ROW1 = 110,
> > +	MX6Q_KEY_COL2 = 111,
> > +	MX6Q_KEY_ROW2 = 112,
> > +	MX6Q_KEY_COL3 = 113,
> > +	MX6Q_KEY_ROW3 = 114,
> > +	MX6Q_KEY_COL4 = 115,
> > +	MX6Q_KEY_ROW4 = 116,
> > +	MX6Q_GPIO_0 = 117,
> > +	MX6Q_GPIO_1 = 118,
> > +	MX6Q_GPIO_9 = 119,
> > +	MX6Q_GPIO_3 = 120,
> > +	MX6Q_GPIO_6 = 121,
> > +	MX6Q_GPIO_2 = 122,
> > +	MX6Q_GPIO_4 = 123,
> > +	MX6Q_GPIO_5 = 124,
> > +	MX6Q_GPIO_7 = 125,
> > +	MX6Q_GPIO_8 = 126,
> > +	MX6Q_GPIO_16 = 127,
> > +	MX6Q_GPIO_17 = 128,
> > +	MX6Q_GPIO_18 = 129,
> > +	MX6Q_GPIO_19 = 130,
> > +	MX6Q_CSI0_PIXCLK = 131,
> > +	MX6Q_CSI0_MCLK = 132,
> > +	MX6Q_CSI0_DATA_EN = 133,
> > +	MX6Q_CSI0_VSYNC = 134,
> > +	MX6Q_CSI0_DAT4 = 135,
> > +	MX6Q_CSI0_DAT5 = 136,
> > +	MX6Q_CSI0_DAT6 = 137,
> > +	MX6Q_CSI0_DAT7 = 138,
> > +	MX6Q_CSI0_DAT8 = 139,
> > +	MX6Q_CSI0_DAT9 = 140,
> > +	MX6Q_CSI0_DAT10 = 141,
> > +	MX6Q_CSI0_DAT11 = 142,
> > +	MX6Q_CSI0_DAT12 = 143,
> > +	MX6Q_CSI0_DAT13 = 144,
> > +	MX6Q_CSI0_DAT14 = 145,
> > +	MX6Q_CSI0_DAT15 = 146,
> > +	MX6Q_CSI0_DAT16 = 147,
> > +	MX6Q_CSI0_DAT17 = 148,
> > +	MX6Q_CSI0_DAT18 = 149,
> > +	MX6Q_CSI0_DAT19 = 150,
> > +	MX6Q_SD3_DAT7 = 151,
> > +	MX6Q_SD3_DAT6 = 152,
> > +	MX6Q_SD3_DAT5 = 153,
> > +	MX6Q_SD3_DAT4 = 154,
> > +	MX6Q_SD3_CMD = 155,
> > +	MX6Q_SD3_CLK = 156,
> > +	MX6Q_SD3_DAT0 = 157,
> > +	MX6Q_SD3_DAT1 = 158,
> > +	MX6Q_SD3_DAT2 = 159,
> > +	MX6Q_SD3_DAT3 = 160,
> > +	MX6Q_SD3_RST = 161,
> > +	MX6Q_NANDF_CLE = 162,
> > +	MX6Q_NANDF_ALE = 163,
> > +	MX6Q_NANDF_WP_B = 164,
> > +	MX6Q_NANDF_RB0 = 165,
> > +	MX6Q_NANDF_CS0 = 166,
> > +	MX6Q_NANDF_CS1 = 167,
> > +	MX6Q_NANDF_CS2 = 168,
> > +	MX6Q_NANDF_CS3 = 169,
> > +	MX6Q_SD4_CMD = 170,
> > +	MX6Q_SD4_CLK = 171,
> > +	MX6Q_NANDF_D0 = 172,
> > +	MX6Q_NANDF_D1 = 173,
> > +	MX6Q_NANDF_D2 = 174,
> > +	MX6Q_NANDF_D3 = 175,
> > +	MX6Q_NANDF_D4 = 176,
> > +	MX6Q_NANDF_D5 = 177,
> > +	MX6Q_NANDF_D6 = 178,
> > +	MX6Q_NANDF_D7 = 179,
> > +	MX6Q_SD4_DAT0 = 180,
> > +	MX6Q_SD4_DAT1 = 181,
> > +	MX6Q_SD4_DAT2 = 182,
> > +	MX6Q_SD4_DAT3 = 183,
> > +	MX6Q_SD4_DAT4 = 184,
> > +	MX6Q_SD4_DAT5 = 185,
> > +	MX6Q_SD4_DAT6 = 186,
> > +	MX6Q_SD4_DAT7 = 187,
> > +	MX6Q_SD1_DAT1 = 188,
> > +	MX6Q_SD1_DAT0 = 189,
> > +	MX6Q_SD1_DAT3 = 190,
> > +	MX6Q_SD1_CMD = 191,
> > +	MX6Q_SD1_DAT2 = 192,
> > +	MX6Q_SD1_CLK = 193,
> > +	MX6Q_SD2_CLK = 194,
> > +	MX6Q_SD2_CMD = 195,
> > +	MX6Q_SD2_DAT3 = 196
> > +};
> > +
> > +/* Pad names for the pinmux subsystem */ static const struct
> > +pinctrl_pin_desc imx6q_pinctrl_pads[] = {
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_DAT1),
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_DAT2),
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_DAT0),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TXC),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TD0),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TD1),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TD2),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TD3),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RX_CTL),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RD0),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_TX_CTL),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RD1),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RD2),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RD3),
> > +	IMX_PINCTRL_PIN(MX6Q_RGMII_RXC),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A25),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_EB2),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D16),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D17),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D18),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D19),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D20),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D21),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D22),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D23),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_EB3),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D24),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D25),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D26),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D27),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D28),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D29),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D30),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_D31),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A24),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A23),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A22),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A21),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A20),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A19),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A18),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A17),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_A16),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_CS0),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_CS1),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_OE),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_RW),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_LBA),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_EB0),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_EB1),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA0),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA1),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA2),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA3),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA4),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA5),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA6),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA7),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA8),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA9),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA10),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA11),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA12),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA13),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA14),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_DA15),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_WAIT),
> > +	IMX_PINCTRL_PIN(MX6Q_EIM_BCLK),
> > +	IMX_PINCTRL_PIN(MX6Q_DI0_DISP_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_DI0_PIN15),
> > +	IMX_PINCTRL_PIN(MX6Q_DI0_PIN2),
> > +	IMX_PINCTRL_PIN(MX6Q_DI0_PIN3),
> > +	IMX_PINCTRL_PIN(MX6Q_DI0_PIN4),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT0),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT1),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT2),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT3),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT4),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT5),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT6),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT7),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT8),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT9),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT10),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT11),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT12),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT13),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT14),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT15),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT16),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT17),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT18),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT19),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT20),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT21),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT22),
> > +	IMX_PINCTRL_PIN(MX6Q_DISP0_DAT23),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_MDIO),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_REF_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_RX_ER),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_CRS_DV),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_RXD1),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_RXD0),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_TX_EN),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_TXD1),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_TXD0),
> > +	IMX_PINCTRL_PIN(MX6Q_ENET_MDC),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_COL0),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_ROW0),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_COL1),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_ROW1),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_COL2),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_ROW2),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_COL3),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_ROW3),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_COL4),
> > +	IMX_PINCTRL_PIN(MX6Q_KEY_ROW4),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_0),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_1),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_9),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_3),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_6),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_2),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_4),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_5),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_7),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_8),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_16),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_17),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_18),
> > +	IMX_PINCTRL_PIN(MX6Q_GPIO_19),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_PIXCLK),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_MCLK),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DATA_EN),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_VSYNC),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT4),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT5),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT6),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT7),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT8),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT9),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT10),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT11),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT12),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT13),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT14),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT15),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT16),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT17),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT18),
> > +	IMX_PINCTRL_PIN(MX6Q_CSI0_DAT19),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT7),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT6),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT5),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT4),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_CMD),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT0),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT1),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT2),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_DAT3),
> > +	IMX_PINCTRL_PIN(MX6Q_SD3_RST),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_CLE),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_ALE),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_WP_B),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_RB0),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_CS0),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_CS1),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_CS2),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_CS3),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_CMD),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D0),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D1),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D2),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D3),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D4),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D5),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D6),
> > +	IMX_PINCTRL_PIN(MX6Q_NANDF_D7),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT0),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT1),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT2),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT3),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT4),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT5),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT6),
> > +	IMX_PINCTRL_PIN(MX6Q_SD4_DAT7),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_DAT1),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_DAT0),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_DAT3),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_CMD),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_DAT2),
> > +	IMX_PINCTRL_PIN(MX6Q_SD1_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_CLK),
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_CMD),
> > +	IMX_PINCTRL_PIN(MX6Q_SD2_DAT3),
> > +};
> > +
> > +struct imx_pinctrl_info imx6q_pinctrl_info = {
> > +	.type = IMX6Q_PINCTRL,
> > +	.pins = imx6q_pinctrl_pads,
> > +	.npins = ARRAY_SIZE(imx6q_pinctrl_pads),
> > +	.maxpin = IMX6Q_IOMUXC_MAXPIN,
> > +	.mux_offset = IMX6Q_IOMUXC_MUX_OFSSET, };


