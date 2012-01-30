Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2A3PbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:31:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63009 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2A3PbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:31:06 -0500
Message-ID: <4F26B7B6.2080107@lwfinger.net>
Date: Mon, 30 Jan 2012 09:31:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: wlanfae@realtek.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [trivial] net: Fix typo in rtl8192de/dm.c
References: <1327930827-1719-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1327930827-1719-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 07:40 AM, Masanari Iida wrote:
> Correct spelling "disconnet" to "disconnect" in
> drivers/net/wireless/rtlwifi/rtl8192de/dm.c
>
> Signed-off-by: Masanari Iida<standby24x7@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/dm.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

The patch is OK, but by convention, the subject should say "[PATCH] rtlwifi: 
rtl8192dm: Fix typo in dm.c". By getting rtlwifi in it, searching the git log is 
a lot easier.

Larry

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
>

