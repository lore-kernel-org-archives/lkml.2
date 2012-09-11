Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2IKG4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:56:14 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37990 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2IKG4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:56:09 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: RE: [PATCH] ARM: OMAP2+: Makefile.boot: Add am335x evm and bone
 targets
Thread-Topic: [PATCH] ARM: OMAP2+: Makefile.boot: Add am335x evm and bone
 targets
Thread-Index: AQHNh6GxwD7RuT1Od0+V6BMLfUH3C5eExXgA
Date: Tue, 11 Sep 2012 06:55:57 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EAB0764@DBDE01.ent.ti.com>
References: <1346435674-6207-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1346435674-6207-1-git-send-email-hvaibhav@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.105]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 23:24:34, Hiremath, Vaibhav wrote:
> This adds am335x-evm and am335x-bone dtb targets to
> 'make dtbs', just like other platforms.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/Makefile.boot |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/Makefile.boot b/arch/arm/mach-omap2/Makefile.boot
> index 6cf1c2d..1136072 100644
> --- a/arch/arm/mach-omap2/Makefile.boot
> +++ b/arch/arm/mach-omap2/Makefile.boot
> @@ -7,3 +7,4 @@ dtb-$(CONFIG_ARCH_OMAP3)	+= omap3-beagle.dtb omap3-evm.dtb
>  dtb-$(CONFIG_ARCH_OMAP4)	+= omap4-panda.dtb omap4-pandaES.dtb
>  dtb-$(CONFIG_ARCH_OMAP4)	+= omap4-var_som.dtb omap4-sdp.dtb
>  dtb-$(CONFIG_SOC_OMAP5)		+= omap5-evm.dtb
> +dtb-$(CONFIG_SOC_AM33XX)	+= am335x-evm.dtb am335x-bone.dtb

Tony,

Gentle reminder on this patch !!!

Thanks,
Vaibhav

> -- 
> 1.7.0.4
> 
> 

