Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab2AaPqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:46:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:34087 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2AaPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:46:35 -0500
Message-ID: <4F280CD7.9080002@lwfinger.net>
Date: Tue, 31 Jan 2012 09:46:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-wireless@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [trivial] rtlwifi: Fix typo in dm.c
References: <1328016875-1684-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1328016875-1684-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 07:34 AM, Masanari Iida wrote:
> Correct a spelling "disconnet" to "disconnect" in
> drivers/net/wireless/rtlwifi/rtl8192de/dm.c
>
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> index 3cd0736..5087fe4 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
> @@ -296,7 +296,7 @@ static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
>   		de_digtable.min_undecorated_pwdb_for_dm =
>   		    rtlpriv->dm.UNDEC_SM_PWDB;
>   		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
> -			 ("AP Ext Port or disconnet PWDB = 0x%x\n",
> +			 ("AP Ext Port or disconnect PWDB = 0x%x\n",
>   			  de_digtable.min_undecorated_pwdb_for_dm));
>   	}

Due to the changes in RT_TRACE, this patch would not apply to the 
wireless-testing tree. I fixed it and submitted a good version with my 
Signed-off-by. Thanks for noticing this, but please use the correct tree when 
submitting patches.

Larry

