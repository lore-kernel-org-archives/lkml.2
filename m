Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2FANzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:55:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53493 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758754Ab2FANzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:55:08 -0400
Message-ID: <4FC8C9A6.1040206@ti.com>
Date: Fri, 1 Jun 2012 08:54:46 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: <jgq516@gmail.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <wim@iguana.be>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCHv2 0/3] omap3 and omap4: add device tree support for wdt
References: <1338525856-4359-1-git-send-email-jgq516@gmail.com>
In-Reply-To: <1338525856-4359-1-git-send-email-jgq516@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.0.155]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/31/2012 11:44 PM, jgq516@gmail.com wrote:
> From: Xiao Jiang <jgq516@gmail.com>
> 
> Changes compared to previous version:
> - created document for omap wdt
> - some modifications per the comments from Benoit and Jon
> 
> This series is based on latest Linus'tree, and also can be applied to dt branch
> of linux-omap tree. Tested with omap4430 blaze board and am37xx board.
> 
> Xiao Jiang (3):
>   arm/dts: add wdt node for omap3 and omap4
>   OMAP: avoid build wdt platform device if with dt support
>   watchdog: omap_wdt: add device tree support
> 
>  .../devicetree/bindings/watchdog/omap-wdt.txt      |   14 ++++++++++++++
>  arch/arm/boot/dts/omap3.dtsi                       |    5 +++++
>  arch/arm/boot/dts/omap4.dtsi                       |    5 +++++
>  arch/arm/mach-omap2/devices.c                      |    2 +-
>  drivers/watchdog/omap_wdt.c                        |    7 +++++++
>  5 files changed, 32 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/watchdog/omap-wdt.txt

Thanks! Looks good to me.

Reviewed-by: Jon Hunter <jon-hunter@ti.com>

Cheers
Jon

