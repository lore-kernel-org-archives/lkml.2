Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2JSOHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:07:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:56587 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab2JSOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:07:06 -0400
Message-ID: <50815E85.8080600@gmail.com>
Date: Fri, 19 Oct 2012 09:07:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 1/2] ARM: multi_v7_defconfig: Add ARCH_MXC
References: <1350605046-21358-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1350605046-21358-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Arnd and Olof.

On 10/18/2012 07:04 PM, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Let ARCH_MXC be covered by multi_v7_defconfig.
> 
> Allow booting mx6 via NFS.

Now we can start debating what should or shouldn't be in shared
defconfigs. :)

My intent with this defconfig was to only enable required options and
all drivers for platforms and leave features to their defaults. I don't
feel that strongly about it. We should have some general guideline here
so it's not a free for all. You can still have a defconfig for your
platform as well.

Rob

> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Provide a more complete config that allows booting mx6 via NFS
> 
>  arch/arm/configs/multi_v7_defconfig |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
> index 159f75f..df1e563 100644
> --- a/arch/arm/configs/multi_v7_defconfig
> +++ b/arch/arm/configs/multi_v7_defconfig
> @@ -5,6 +5,8 @@ CONFIG_ARCH_MVEBU=y
>  CONFIG_MACH_ARMADA_370=y
>  CONFIG_MACH_ARMADA_XP=y
>  CONFIG_ARCH_HIGHBANK=y
> +CONFIG_ARCH_MXC=y
> +CONFIG_SOC_IMX6Q=y
>  CONFIG_ARCH_SOCFPGA=y
>  # CONFIG_ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA is not set
>  CONFIG_ARM_ERRATA_754322=y
> @@ -17,18 +19,29 @@ CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_VFP=y
>  CONFIG_NEON=y
>  CONFIG_NET=y
> +CONFIG_PACKET=y
> +CONFIG_UNIX=y
> +CONFIG_INET=y
> +CONFIG_IP_PNP=y
> +CONFIG_IP_PNP_DHCP=y
>  CONFIG_ATA=y
>  CONFIG_SATA_HIGHBANK=y
>  CONFIG_NETDEVICES=y
>  CONFIG_NET_CALXEDA_XGMAC=y
>  CONFIG_SMSC911X=y
>  CONFIG_STMMAC_ETH=y
> +CONFIG_NFS_FS=y
> +CONFIG_NFS_V3_ACL=y
> +CONFIG_NFS_V4=y
> +CONFIG_ROOT_NFS=y
>  CONFIG_SERIO_AMBAKMI=y
>  CONFIG_SERIAL_8250=y
>  CONFIG_SERIAL_8250_CONSOLE=y
>  CONFIG_SERIAL_8250_DW=y
>  CONFIG_SERIAL_AMBA_PL011=y
>  CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
> +CONFIG_SERIAL_IMX=y
> +CONFIG_SERIAL_IMX_CONSOLE=y
>  CONFIG_SERIAL_OF_PLATFORM=y
>  CONFIG_IPMI_HANDLER=y
>  CONFIG_IPMI_SI=y
> 

