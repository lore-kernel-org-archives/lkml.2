Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2IFITu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 04:19:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36990 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2IFITq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 04:19:46 -0400
Date: Thu, 6 Sep 2012 16:19:57 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] pwm i.MX: add devicetree support
Message-ID: <20120906081954.GD2362@S2101-09.ap.freescale.net>
References: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 03:35:19PM +0200, Sascha Hauer wrote:
> 
> Changes since v1:
> 
> - Add devicetree binding documentation
> - Merge 5/9 and 9/9
> - fix #pwm-cells (must be 2 instead of 3)
> - fix wrong name in MODULE_DEVICE_TABLE
> - drop platform based probing while introducing devicetree based probe
> 
> ----------------------------------------------------------------
> Philipp Zabel (2):
>       pwm i.MX: add devicetree support
>       pwm i.MX: fix clock lookup
> 
> Sascha Hauer (6):
>       pwm i.MX: factor out SoC specific functions
>       pwm i.MX: remove unnecessary if in pwm_[en|dis]able
>       pwm i.MX: add functions to enable/disable pwm.
>       pwm i.MX: Use module_platform_driver
>       pwm i.MX: use per clock unconditionally
>       ARM i.MX53: Add pwm support
> 
For the series,

Reviewed-by: Shawn Guo <shawn.guo@linaro.org>

>  Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
>  arch/arm/boot/dts/imx53.dtsi                      |   14 ++
>  arch/arm/mach-imx/clk-imx51-imx53.c               |    4 +
>  drivers/pwm/pwm-imx.c                             |  275 ++++++++++++++-------
>  4 files changed, 214 insertions(+), 96 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt
> 
