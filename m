Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2IUOjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:39:52 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2925 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab2IUOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:39:51 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <505C7C27.2050108@broadcom.com>
Date: Fri, 21 Sep 2012 16:39:35 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-Version: 1.0
To: "Wei Ni" <wni@nvidia.com>
cc: swarren@wwwdotorg.org, krakesh@nvidia.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] ARM: tegra: enable brcmfmac in defconfig
References: <1348217700-12309-1-git-send-email-wni@nvidia.com>
 <1348217700-12309-6-git-send-email-wni@nvidia.com>
In-Reply-To: <1348217700-12309-6-git-send-email-wni@nvidia.com>
X-WSS-ID: 7C42A47A3MK37091618-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 10:55 AM, Wei Ni wrote:
> New options enabled:
> * CFG80211_WEXT: (dependency)
> * BRCMFMAC: wlan driver, enable as module.
>
> Signed-off-by: Wei Ni <wni@nvidia.com>
> ---
>   arch/arm/configs/tegra_defconfig |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
> index adcf3c2..04b18ea 100644
> --- a/arch/arm/configs/tegra_defconfig
> +++ b/arch/arm/configs/tegra_defconfig
> @@ -73,6 +73,7 @@ CONFIG_BT_BNEP=y
>   CONFIG_BT_HIDP=y
>   CONFIG_BT_HCIBTUSB=m
>   CONFIG_CFG80211=y
> +CONFIG_CFG80211_WEXT=y

Any particular reason for enabling this? The driver does not 
specifically need it. The option only allows use of WEXT dependent 
user-space tools like iwconfig and iwlist. At least it is not needed by 
brcmfmac driver hence it does not select it.

You indicate there is a dependency. Could you elaborate?

Gr. AvS


