Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab2A3Xfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 18:35:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52525 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2A3Xfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 18:35:45 -0500
Message-ID: <4F27294D.30302@lwfinger.net>
Date: Mon, 30 Jan 2012 17:35:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Devendra.Naga" <devendra.aaru@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wireless: remove return in _rtl_pci_switch_clk_req
References: <1327927591-28070-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1327927591-28070-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 06:46 AM, Devendra.Naga wrote:
> From: "Devendra.Naga"<devendra.aaru@gmail.com>
>
> the return value from _rtl_pci_switch_clk_req is not used by any of its callers.
>
> Signed-off-by: Devendra.Naga<devendra.aaru@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)

The patch is OK, but the patch subject is bad. You should have "[PATCH] 
rtlwifi:...". Your patch is for rtlwifi, not wireless.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 4326fd1..35f4a0d 100644
> --- a/drivers/net/wireless/rtlwifi/pci.c
> +++ b/drivers/net/wireless/rtlwifi/pci.c
> @@ -198,7 +198,7 @@ static bool _rtl_pci_platform_switch_device_pci_aspm(
>   }
>
>   /*When we set 0x01 to enable clk request. Set 0x0 to disable clk req.*/
> -static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
> +static void _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
>   {
>   	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>   	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
> @@ -208,7 +208,6 @@ static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
>   	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
>   		udelay(100);
>
> -	return true;
>   }
>
>   /*Disable RTL8192SE ASPM&  Disable Pci Bridge ASPM*/

