Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0DNGd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:33:28 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60237 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0DNGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:33:27 -0400
Message-ID: <4BC561B5.1020006@canonical.com>
Date: Tue, 13 Apr 2010 23:33:25 -0700
From: Bryan Wu <bryan.wu@canonical.com>
Reply-To: bryan.wu@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100404 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux@arm.linux.org.uk, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       r.herring@freescale.com, amit.kucheria@canonical.com
Subject: Re: [PATCH 2.6.34-rc4 7/8] mx5: Add USB to Freescale MX51 Babbage
References: <1271175030-3635-1-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-2-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-3-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-4-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-5-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-6-git-send-email-Dinh.Nguyen@freescale.com> <1271175030-3635-7-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1271175030-3635-7-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks OK for me, but I failed to find the 8th patch of this patchset.
Did you forget to send it out?

-Bryan

On 04/13/2010 09:10 AM, Dinh.Nguyen@freescale.com wrote:
> From: Dinh Nguyen<Dinh.Nguyen@freescale.com>
>
> Updade mx51_defconfig to include USB host support.
> This patch applies to 2.6.34-rc4.
>
> Signed-off-by: Dinh Nguyen<Dinh.Nguyen@freescale.com>
> ---
>   arch/arm/configs/mx51_defconfig |   17 ++++++++++++++++-
>   1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
> index c88e952..a708fd6 100644
> --- a/arch/arm/configs/mx51_defconfig
> +++ b/arch/arm/configs/mx51_defconfig
> @@ -809,7 +809,22 @@ CONFIG_SSB_POSSIBLE=y
>   CONFIG_DUMMY_CONSOLE=y
>   # CONFIG_SOUND is not set
>   # CONFIG_HID_SUPPORT is not set
> -# CONFIG_USB_SUPPORT is not set
> +CONFIG_USB_SUPPORT=y
> +CONFIG_USB_ARCH_HAS_HCD=y
> +# CONFIG_USB_ARCH_HAS_OHCI is not set
> +CONFIG_USB_ARCH_HAS_EHCI=y
> +CONFIG_USB=y
> +
> +#
> +# USB Host Controller Drivers
> +#
> +# CONFIG_USB_C67X00_HCD is not set
> +CONFIG_USB_EHCI_HCD=y
> +CONFIG_USB_EHCI_ROOT_HUB_TT=y
> +# CONFIG_USB_EHCI_TT_NEWSCHED is not set
> +CONFIG_USB_EHCI_MXC=y
> +
> +
>   CONFIG_MMC=y
>   # CONFIG_MMC_DEBUG is not set
>   # CONFIG_MMC_UNSAFE_RESUME is not set

