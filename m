Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2JVQTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:19:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52053 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755561Ab2JVQTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:19:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Zkc4ShHSBzPh/Fa9huNmK
Date: Mon, 22 Oct 2012 09:19:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: b-cousson@ti.com, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] arm: dts: omap4-sdp: pinmux configuration for keypad
Message-ID: <20121022161909.GY4730@atomide.com>
References: <1350890955-29553-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350890955-29553-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sourav Poddar <sourav.poddar@ti.com> [121022 00:30]:
> --- a/arch/arm/boot/dts/omap4-sdp.dts
> +++ b/arch/arm/boot/dts/omap4-sdp.dts
> @@ -194,6 +194,27 @@
>  			0xbc 0x100	/* abe_mcbsp2_fsx.abe_mcbsp2_fsx INPUT | MODE0 */
>  		>;
>  	};
> +
> +	keypad_pins: pinmux_keypad_pins {
> +		pinctrl-single,pins = <
> +			0x24 0x4119   /* gpmc_a18.kpd_row6 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x26 0x4119   /* gpmc_a19.kpd_row6 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x2c 0x4001   /* gpmc_a22.kpd_col6 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x2e 0x4001   /* gpmc_a23.kpd_col7 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x13c 0x4001  /* kpd_col0.kpd_col0 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x13e 0x4001  /* kpd_col1.kpd_col1 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x140 0x4001  /* kpd_col2.kpd_col2 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x142 0x10F   /* kpd_col3.kpd_col3 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x144 0x4001  /* kpd_col4.kpd_col4 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x146 0x4001  /* kpd_col5.kpd_col5 OMAP_WAKEUP_EN | OMAP_MUX_MODE1 */
> +			0x148 0xc119  /* kpd_row0.kpd_row0 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x14a 0x4119  /* kpd_row1.kpd_row1 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x14c 0x4119  /* kpd_row2.kpd_row2 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x14e 0x4119  /* kpd_row3.kpd_row3 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x150 0x4119  /* kpd_row4.kpd_row4 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +			0x152 0x4119  /* kpd_row5.kpd_row5 OMAP_PULL_ENA | OMAP_PULL_UP | OMAP_WAKEUP_EN | OMAP_MUX_MODE1 | OMAP_INPUT_EN */
> +		>;
> +	};
>  };

Please shorten these to leave out OMAP_:

		pinctrl-single,pins = <
			0x24 0x4119   /* gpmc_a18.kpd_row6 PULL_ENA | PULL_UP | WAKEUP_EN | MUX_MODE1 | INPUT_EN */
			0x26 0x4119   /* gpmc_a19.kpd_row6 PULL_ENA | PULL_UP | WAKEUP_EN | MUX_MODE1 | INPUT_EN */
			...

When we convert them over to use the preprocessor, we can still
easily replace them.

Regards,

Tony
