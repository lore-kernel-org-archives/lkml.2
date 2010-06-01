Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0FAMc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:32:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39270 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0FAMc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:32:26 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
Date: Tue, 1 Jun 2010 18:02:20 +0530
Subject: RE: [2.6.35-rc1, patch] omap2/3 ohci build failure...
Thread-Topic: [2.6.35-rc1, patch] omap2/3 ohci build failure...
Thread-Index: AcsBhdl4HfP6LME0RxyotOqhf5KHzAAAC29Q
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0323207428@dbde02.ent.ti.com>
References: <AANLkTimtfC5mRVNCW5Qv_6yV3_qfYn1_1sF_9lNL59LP@mail.gmail.com>
In-Reply-To: <AANLkTimtfC5mRVNCW5Qv_6yV3_qfYn1_1sF_9lNL59LP@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> Fix the 'DMA_BIT_MASK' missing symbol causing build failure when
> building 2.6.35-rc1 for an TI OMAP2/3 platform.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 

Thanks. A similar patch was posted by Amit Kucheria [1].

In addition, you need a patch at [2]. I think Tony has queued these.

- Anand

[1] <https://patchwork.kernel.org/patch/101692/>
[2] <https://patchwork.kernel.org/patch/102917/>

> diff --git a/arch/arm/mach-omap2/usb-ehci.c b/arch/arm/mach-omap2/usb-ehci.c
> index c68f799..d1a4f22 100644
> --- a/arch/arm/mach-omap2/usb-ehci.c
> +++ b/arch/arm/mach-omap2/usb-ehci.c
> @@ -19,6 +19,7 @@
>  #include <linux/errno.h>
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
>  #include <linux/clk.h>
>  #include <asm/io.h>
>  #include <plat/mux.h>
> -- 
> Daniel J Blueman
> 