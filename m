Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab2HHSnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 14:43:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34551 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab2HHSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:43:19 -0400
Message-ID: <5022B342.7080606@wwwdotorg.org>
Date: Wed, 08 Aug 2012 12:43:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: vt8500-wm8505-linux-kernel@googlegroups.com, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-doc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Eric Andersson <eric.andersson@unixphere.com>,
        linux-serial@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@nvidia.com>, Neil Zhang <zhangwm@marvell.com>,
        linux-arm-kernel@lists.infradead.org, Alan Cox <alan@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 1/8] arm: vt8500: Add device tree files for VIA/Wondermedia
 SoC's
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-2-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1344389967-8465-2-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 07:39 PM, Tony Prisk wrote:
> Add device tree files for VT8500, WM8505 and WM8650 SoC's and
> reference boards.

> diff --git a/arch/arm/boot/dts/vt8500_ref.dts b/arch/arm/boot/dts/vt8500_ref.dts

It appears more typical to use "-" rather than "_" in the filename to
join SoC and board names.

I guess "_ref" means "reference". Is that how the boards are commonly
known? Are you sure there will never be another reference board for
these SoCs? Given the "model" values in the file, something more like
vt8500-bv07.dts might be more appropriate?

> +	/*
> +	 * Display node is based on Sascha Hauer's patch on dri-devel.
> +	 * Added a bpp property to calculate the size of the framebuffer
> +	 * until the binding is formalized.
> +	 */
> +	display {

Maybe it's better to just hold off on adding this node, to wait until
the binding is complete so this file doesn't churn? Certainly it sounded
like Sascha was going to change the binding a little in response to
comments it received.
