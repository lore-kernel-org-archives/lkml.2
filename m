Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab2DJCSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 22:18:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49216 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2DJCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 22:18:38 -0400
Date: Tue, 10 Apr 2012 10:19:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH 3/4] clk: add DT clock binding support
Message-ID: <20120410021922.GH18692@S2101-09.ap.freescale.net>
References: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
 <1334003101-17274-4-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334003101-17274-4-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 03:25:00PM -0500, Rob Herring wrote:
...
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/fixed-clock.txt
> @@ -0,0 +1,22 @@
> +Binding for simple fixed-rate clock sources.
> +
> +This binding uses the common clock binding[1].
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible : shall be "fixed-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clock-frequency : frequency of clock in Hz. Should be a single cell.
						 ^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Optional properties:
> +- gpios : From common gpio binding; gpio connection to clock enable pin.

I haven't seen this support in the code yet.

> +- clock-output-names : From common clock binding. Required for nodes with
> +  multiple outputs.

This seems inconsistent with above "Should be a single cell."

Regards,
Shawn

> +
> +Example:
> +	clock {
> +		compatible = "fixed-clock";
> +		#clock-cells = <0>;
> +		clock-frequency = <1000000000>;
> +	};
