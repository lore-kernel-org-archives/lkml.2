Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1IBIH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:07:29 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52318 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab1IBIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:07:22 -0400
Date: Fri, 2 Sep 2011 11:04:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: Fix whitespace issues
Message-ID: <20110902080457.GE2430@shale.localdomain>
References: <1314949913-13090-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314949913-13090-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 12:51:53AM -0700, Gerard Snitselaar wrote:
>  #define MAX_LD_SLOT_NUM 10
> -#define KEEP_ALIVE_INTERVAL 				20 // in seconds.
> +#define KEEP_ALIVE_INTERVAL				20 // in seconds.
>  #define CHECK_FOR_HANG_PERIOD			2 //be equal to watchdog check time
>  #define DEFAULT_KEEP_ALIVE_LEVEL			1
>  #define DEFAULT_SLOT_NUM					2

It would be better if the 1 and 2 were lined up.

> @@ -591,14 +591,14 @@ typedef struct r8180_priv
>  	int	   ForcedDataRate; // Force Data Rate. 0: Auto, 0x02: 1M ~ 0x6C: 54M.)
>  	u32     NumTxUnicast; //YJ,add,080828,for keep alive
>  	u8      keepAliveLevel; //YJ,add,080828,for KeepAlive
> -	unsigned long 	NumTxOkTotal;
> +	unsigned long	NumTxOkTotal;
>  	u16                                 LastRetryCnt;
>          u16                                     LastRetryRate;
>          unsigned long       LastTxokCnt;
>          unsigned long           LastRxokCnt;
>          u16                                     CurrRetryCnt;
>          unsigned long           LastTxOKBytes;
> -	unsigned long 		    NumTxOkBytesTotal;
> +	unsigned long		    NumTxOkBytesTotal;
>          u8                          LastFailTxRate;
>          long                        LastFailTxRateSS;
>          u8                          FailTxRateCount;

These are all higgledy-piggledy.

> @@ -579,7 +579,7 @@ StaRateAdaptive87SE(
>  	u32			TxThroughput;
>  	long		CurrSignalStrength;
>  	bool		bUpdateInitialGain = false;
> -    	u8			u1bOfdm=0, u1bCck = 0;
> +	u8			u1bOfdm=0, u1bCck = 0;
                                      ^^^
Spaces around the '=' char.

> @@ -846,7 +846,7 @@ StaRateAdaptive87SE(
>  			bTryDown = true;
>  			priv->TryDownCountLowData += TryDownTh;
>  		}
> -  		else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) //TO DO: need to consider (RSSI)
> +		else if ( (CurrRetryRate<20) && (priv->LastRetryRate<21)) //TO DO: need to consider (RSSI)
                         ^             ^^^                         ^^^
Delete extra space, add spaces around the '<' chars.

> --- a/drivers/staging/rtl8187se/r8185b_init.c
> +++ b/drivers/staging/rtl8187se/r8185b_init.c
> @@ -172,7 +172,7 @@ if (offset == PhyAddr)	{
>  		*/
>  /*		NdisAcquireSpinLock( &(pDevice->IoSpinLock) );	*/
>  
> -		for (idx = 0; idx < 30; idx++)	{ 
> +		for (idx = 0; idx < 30; idx++)	{
                                               ^
Delete the second space here.

regards,
dan carpenter

