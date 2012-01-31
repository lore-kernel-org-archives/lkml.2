Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2AaPw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:52:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63297 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab2AaPw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:52:27 -0500
Message-ID: <4F280E37.8030803@lwfinger.net>
Date: Tue, 31 Jan 2012 09:52:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Devendra.Naga" <devendra.aaru@gmail.com>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: remove return in _rtl_pci_switch_clk_req
References: <1327991295-6258-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1327991295-6258-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 12:28 AM, Devendra.Naga wrote:
> From: "Devendra.Naga"<devendra.aaru@gmail.com>
>
> the return value from _rtl_pci_switch_clk_req is not used by any of its callers.
>
> Signed-off-by: Devendra.Naga<devendra.aaru@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/pci.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
> index 5cb2199..9a01909 100644
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
> @@ -207,8 +207,6 @@ static bool _rtl_pci_switch_clk_req(struct ieee80211_hw *hw, u8 value)
>
>   	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192SE)
>   		udelay(100);
> -
> -	return true;
>   }
>
>   /*Disable RTL8192SE ASPM&  Disable Pci Bridge ASPM*/

