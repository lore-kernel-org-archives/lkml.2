Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936886Ab0COVmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:42:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38817 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0COVmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:42:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9EA9D7.9050009@s5r6.in-berlin.de>
Date: Mon, 15 Mar 2010 22:42:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Thomas Weber <swirl@gmx.li>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Fix typo: paramters => parameters
References: <1268686738-28293-1-git-send-email-swirl@gmx.li> <1268686738-28293-4-git-send-email-swirl@gmx.li>
In-Reply-To: <1268686738-28293-4-git-send-email-swirl@gmx.li>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Weber wrote:
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -2364,7 +2364,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
>  				u8		u1bAIFS;
>  				u32		u4bAcParam;
>  				pAcParam = (PAC_PARAM)(&AcParam);
> -				// Retrive paramters to update.
> +				// Retrive parameters to update.
>  				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *(((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
>  				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
>  					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
> @@ -2400,7 +2400,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
>  			u8		u1bAIFS;
>  			u32		u4bAcParam;
>  
> -			// Retrive paramters to update.
> +			// Retrive parameters to update.
>  			eACI = pAcParam->f.AciAifsn.f.ACI;
>  			//Mode G/A: slotTimeTimer = 9; Mode B: 20
>  			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
> diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
> index 519383e..f22275e 100644
> --- a/drivers/staging/rtl8187se/r8185b_init.c
> +++ b/drivers/staging/rtl8187se/r8185b_init.c
> @@ -1128,7 +1128,7 @@ ActUpdateChannelAccessSetting(
>  				u8		u1bAIFS;
>  				u32		u4bAcParam;
>  
> -				// Retrive paramters to update.
> +				// Retrive parameters to update.

See my comment on [PATCH 2/4] Fix typo: udpate => update.
  - "Retrieve"
  - potential conflicts /if/ cleanups are underway in this staging code
-- 
Stefan Richter
-=====-==-=- --== -====
http://arcgraph.de/sr/
