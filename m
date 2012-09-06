Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab2IFQtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:49:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54862 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230Ab2IFQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:49:34 -0400
Message-ID: <5048D41A.5060906@lwfinger.net>
Date: Thu, 06 Sep 2012 11:49:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: kernel-janitors@vger.kernel.org, Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] drivers/net/wireless/rtlwifi/rtl8192de/phy.c: removes
 unnecessary semicolon
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com> <1346947757-10481-10-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1346947757-10481-10-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 11:09 AM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> removes unnecessary semicolon
>
> Found by Coccinelle: http://coccinelle.lip6.fr/
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -u -p a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -1314,7 +1314,7 @@ static void _rtl92d_phy_restore_rf_env(s
>   	struct bb_reg_def *pphyreg = &rtlphy->phyreg_def[rfpath];
>
>   	RT_TRACE(rtlpriv, COMP_RF, DBG_LOUD, "=====>\n");
> -	/*----Restore RFENV control type----*/ ;
> +	/*----Restore RFENV control type----*/
>   	switch (rfpath) {
>   	case RF90_PATH_A:
>   	case RF90_PATH_C:
>
>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

