Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab2LSFnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:43:15 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43446 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2LSFnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <1355843426-13613-1-git-send-email-gautam.vivek@samsung.com>
References: <1355843426-13613-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 19 Dec 2012 11:13:03 +0530
Message-ID: <CAFp+6iERnekpa5Ast0x5efph3AKbJ24xpRpq8jKxdqvSO6LbeA@mail.gmail.com>
Subject: Re: [PATCH v2] Adding USB 3.0 DRD-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org
Cc: dianders@chromium.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        av.tikhomirov@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson.


On Tue, Dec 18, 2012 at 8:40 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Changes form v1:
>  - Moved architecture related patch out of this patch-set.
>  - Replaced unnecessary multi-line macro definitions by
>    single line definitions.
>  - Creating new data structure for USB 3.0 phy type and embedding
>    it in 'samsung_usbphy' structure.
>  - Adding a flag in 'samsung_usbphy' structure to check if device
>    has usb 3.0 type phy or not.
>  - Restructuring probe sequence for USB 3.0 phy, such that we are
>    initializing only when device has usb3.0 type phy.
>
> This patchset is based on the following patch-sets:
>  - https://lkml.org/lkml/2012/12/18/201
>  - http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/134476.html
>  - https://lkml.org/lkml/2012/12/18/187
>
> Vivek Gautam (1):
>   usb: phy: samsung: Add support for USB 3.0 phy for exynos5250
>
>  drivers/usb/phy/samsung-usbphy.c |  339 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 337 insertions(+), 2 deletions(-)
>
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
