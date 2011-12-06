Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1LFH0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:26:30 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:16033
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932566Ab1LFH03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:26:29 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 15:39:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>
Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Message-ID: <20111206073908.GC3712@S2100-06.ap.freescale.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322999384-7886-1-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 07:49:42PM +0800, Dong Aisheng wrote:
> +static struct platform_device_id imx_pinctrl_devtype[] = {
> +	{
> +		.name = "sdhci-pinctrl-imx53",
> +		.driver_data = (kernel_ulong_t)&mx53_pinctrl_info,
> +	}, {
> +		.name = "sdhci-pinctrl-imx6q",
> +		.driver_data = (kernel_ulong_t)&mx6q_pinctrl_info,
> +	},
> +};

The platform_device_id table needs an empty entry to be the sentinel.

-- 
Regards,
Shawn

