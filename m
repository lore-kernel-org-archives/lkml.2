Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1B1Gss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:48:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:49441 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1B1Gsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:48:47 -0500
Date: Mon, 28 Feb 2011 15:47:35 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH v2 07/09] ARM: s3c2440: gta02: Call
 regulator_has_full_constraints
In-reply-to: <1297133720-18178-1-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000b01cbd713$658693a0$3093bae0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvHO3IDLX8EPy3NQiasBWeIjodkYQP1+Kag
References: <1297043521-21903-7-git-send-email-lars@metafoo.de>
 <1297133720-18178-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> This allows the regulator core to disable all regulators which are not in
use
> at the end of the kernel init phase.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index 01e0930..2682592 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -590,6 +590,8 @@ static void __init gta02_machine_init(void)
> 
>  	platform_add_devices(gta02_devices, ARRAY_SIZE(gta02_devices));
>  	pm_power_off = gta02_poweroff;
> +
> +	regulator_has_full_constraints();
>  }
> 
> 
> --

Ok, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

