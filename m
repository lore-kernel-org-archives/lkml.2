Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab0G3B6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 21:58:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38109 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0G3B6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 21:58:09 -0400
Date: Fri, 30 Jul 2010 10:57:41 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the tegra tree with the s5p tree
In-reply-to: <20100730105834.d7ac047f.sfr@canb.auug.org.au>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Erik Gilling'" <konkers@android.com>,
        "'Colin Cross'" <ccross@android.com>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Changhwan Youn'" <chaos.youn@samsung.com>
Message-id: <015801cb2f8a$9bca9b90$d35fd2b0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcsvglgRLjnGAxeBSFKtzjZCcz21VgAB9nww
References: <20100730105834.d7ac047f.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi all,
> 
Hi,

> Today's linux-next merge of the tegra tree got a conflict in
> arch/arm/mm/Kconfig between commit
> 9d2ef2d3944bb387df220fdeec93abc38b62b627 ("ARM: S5PV310: Add new
> Kconfig
> and Makefiles") from the s5p tree and commit
> 7e3b9536bd5ba23b3c94055bdf8c2fd45d9f8e62 ("[ARM] tegra: initial tegra
> support") from the tegra tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

If there is some conflicts, how can/should I do for it...
Stephen, please let me know.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mm/Kconfig
> index d6ffcee,aa26573..0000000
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@@ -772,7 -783,7 +772,7 @@@ config CACHE_L2X
>   	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP ||
> MACH_REALVIEW_PB1176 || \
>   		   REALVIEW_EB_A9MP || ARCH_MX35 || ARCH_MX31 ||
> MACH_REALVIEW_PBX || \
>   		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_U8500 ||
> ARCH_VEXPRESS_CA9X4 || \
> - 		   ARCH_S5PV310
>  -		   ARCH_TEGRA
> ++		   ARCH_S5PV310 || ARCH_TEGRA
>   	default y
>   	select OUTER_CACHE
>   	select OUTER_CACHE_SYNC

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

