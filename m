Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2JEPYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:24:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54602 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2JEPYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:24:45 -0400
Date: Fri, 5 Oct 2012 17:24:43 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH] pwm: dt: Fix description of second PWM cell
Message-ID: <20121005152443.GW1322@pengutronix.de>
References: <1349074053-18385-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349074053-18385-1-git-send-email-thierry.reding@avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:24:26 up 104 days,  6:36, 46 users,  load average: 10.38, 11.93,
 7.26
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:47:33AM +0200, Thierry Reding wrote:
> The second cell in the PWM specifier denotes the period in nanoseconds,
> not the duty cycle. The latter can be freely configured at runtime and
> a PWM with a fixed duty cycle would be rather pointless.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: "Benoît Thébaudeau" <benoit.thebaudeau@advansee.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  Documentation/devicetree/bindings/pwm/imx-pwm.txt            | 2 +-
>  Documentation/devicetree/bindings/pwm/mxs-pwm.txt            | 2 +-
>  Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> index 9b9b185..8522bfb 100644
> --- a/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> @@ -4,7 +4,7 @@ Required properties:
>  - compatible: should be "fsl,<soc>-pwm"
>  - reg: physical base address and length of the controller's registers
>  - #pwm-cells: should be 2.  The first cell specifies the per-chip index
> -  of the PWM to use and the second cell is the duty cycle in nanoseconds.
> +  of the PWM to use and the second cell is the period in nanoseconds.
>  - interrupts: The interrupt for the pwm controller
>  
>  Example:
> diff --git a/Documentation/devicetree/bindings/pwm/mxs-pwm.txt b/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
> index b16f4a5..d7946be6 100644
> --- a/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
> @@ -4,7 +4,7 @@ Required properties:
>  - compatible: should be "fsl,imx23-pwm"
>  - reg: physical base address and length of the controller's registers
>  - #pwm-cells: should be 2.  The first cell specifies the per-chip index
> -  of the PWM to use and the second cell is the duty cycle in nanoseconds.
> +  of the PWM to use and the second cell is the period in nanoseconds.
>  - fsl,pwm-number: the number of PWM devices
>  
>  Example:
> diff --git a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
> index bbbeedb..01438ec 100644
> --- a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
> @@ -7,7 +7,7 @@ Required properties:
>  - reg: physical base address and length of the controller's registers
>  - #pwm-cells: On Tegra the number of cells used to specify a PWM is 2. The
>    first cell specifies the per-chip index of the PWM to use and the second
> -  cell is the duty cycle in nanoseconds.
> +  cell is the period in nanoseconds.
>  
>  Example:
>  
> -- 
> 1.7.12.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
