Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0CUG67 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 02:58:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541Ab0CUG65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 02:58:57 -0400
Date: Sun, 21 Mar 2010 07:58:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: winbond: localpara.h whitespace and
 indentation fixes.
Message-ID: <20100321065847.GC11917@elf.ucw.cz>
References: <1268727716-20422-1-git-send-email-lindley@coyote.org>
 <4BA25348.1080308@cs.helsinki.fi>
 <4BA2B0AB.4070607@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2B0AB.4070607@coyote.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-03-19 00:00:59, Lars Lindley wrote:
> On 2010-03-18 17:22, Pekka Enberg wrote:
> > Lars Lindley wrote:
> >> +/* refer Bitmap2RateValue table */
> >> +#define LOCAL_ALL_SUPPORTED_RATES_BITMAP    0x130c1a66 /*
> >> +                                * the bitmap value
> >> +                                * of all the H/W
> >> +                                * supported rates:
> >> +                                * 1, 2, 5.5, 11,
> >> +                                * 6, 9, 12, 18,
> >> +                                * 24, 36, 48, 54
> >> +                                */
> > 
> > The comments look funny. You might want to move them above the #defines.
> >
> >> +    u8    region;        /* real region setting of the device */
> >> +    u8    Reserved_1[2];
> >> +
> >> +/* power-save variables */
> > 
> > I think this wants to be moved one indentation level to the right.
> > 
> Ok here's a patch that applies over the old one to fix this..
> Hope it looks all right.. :)
> 
> /Lars 
> 
> 
> 
> [PATCH] staging: winbond: localpara.h Moved around some comments
> 
> I moved some comments after pointers from Pekka Enberg.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ACK.

> ---
>  drivers/staging/winbond/localpara.h |   50 ++++++++++++++---------------------
>  1 files changed, 20 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
> index f1e6b50..d798057 100644
> --- a/drivers/staging/winbond/localpara.h
> +++ b/drivers/staging/winbond/localpara.h
> @@ -47,23 +47,13 @@
>  #define BAND_TYPE_OFDM_5		2
>  
>  /* refer Bitmap2RateValue table */
> -#define LOCAL_ALL_SUPPORTED_RATES_BITMAP	0x130c1a66 /*
> -							    * the bitmap value
> -							    * of all the H/W
> -							    * supported rates:
> -							    * 1, 2, 5.5, 11,
> -							    * 6, 9, 12, 18,
> -							    * 24, 36, 48, 54
> -							    */
> -#define LOCAL_OFDM_SUPPORTED_RATES_BITMAP	0x130c1240 /*
> -							    * the bitmap value
> -							    * of all the H/W
> -							    * supported rates
> -							    * except to non-OFDM
> -							    * rates:
> -							    * 6, 9, 12, 18,
> -							    * 24, 36, 48, 54
> -							    */
> +
> +/* the bitmap value of all the H/W supported rates: */
> +/* 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54 */
> +#define LOCAL_ALL_SUPPORTED_RATES_BITMAP	0x130c1a66
> +/* the bitmap value of all the H/W supported rates except to non-OFDM rates: */
> +/* 6, 9, 12, 18, 24, 36, 48, 54 */
> +#define LOCAL_OFDM_SUPPORTED_RATES_BITMAP	0x130c1240
>  #define LOCAL_11B_SUPPORTED_RATE_BITMAP		0x826
>  #define LOCAL_11B_BASIC_RATE_BITMAP		0x826
>  #define LOCAL_11B_OPERATION_RATE_BITMAP		0x826
> @@ -143,7 +133,7 @@ struct wb_local_para {
>  	u8	region;		/* real region setting of the device */
>  	u8	Reserved_1[2];
>  
> -/* power-save variables */
> +	/* power-save variables */
>  	u8	iPowerSaveMode; /* 0 indicates on, 1 indicates off */
>  	u8	ATIMmode;
>  	u8	ExcludeUnencrypted;
> @@ -152,7 +142,7 @@ struct wb_local_para {
>  	u8	boHasTxActivity;/* tx activity has occurred */
>  	u8	boMacPsValid;	/* Power save mode obtained from H/W is valid or not */
>  
> -/* Rate */
> +	/* Rate */
>  	u8	TxRateMode; /*
>  			     * Initial, input from Registry,
>  			     * may be updated by GUI
> @@ -166,7 +156,7 @@ struct wb_local_para {
>  					 */
>  	u8	CurrentTxFallbackRate;
>  
> -/* for Rate handler */
> +	/* for Rate handler */
>  	u8	BRateSet[32];		/* basic rate set */
>  	u8	SRateSet[32];		/* support rate set */
>  
> @@ -180,7 +170,7 @@ struct wb_local_para {
>  	u32	dwSupportRateBitmap;	/* bit map of all support rates including basic and operational rates */
>  
>  
> -/* For SME/MLME handler */
> +	/* For SME/MLME handler */
>  
>  	u16	wOldSTAindex;		/* valid when boHandover=TRUE, store old connected STA index */
>  	u16	wConnectedSTAindex;	/* Index of peerly connected AP or IBSS in the descriptionset. */
> @@ -204,7 +194,7 @@ struct wb_local_para {
>  	u8	CWMin;			/* 255: set according to 802.11 spec. */
>  	u8	reserved2;
>  
> -/* 11G: */
> +	/* 11G: */
>  	u8	bMacOperationMode;	/* operation in 802.11b or 802.11g */
>  	u8	bSlotTimeMode;		/* AUTO, s32 */
>  	u8	bPreambleMode;		/* AUTO, s32 */
> @@ -218,11 +208,11 @@ struct wb_local_para {
>  	u32	RSN_IE_Bitmap;
>  	u32	RSN_OUI_Type;
>  
> -/* For the BSSID */
> +	/* For the BSSID */
>  	u8	HwBssid[MAC_ADDR_LENGTH + 2];
>  	u32	HwBssidValid;
>  
> -/* For scan list */
> +	/* For scan list */
>  	u8	BssListCount;		/* Total count of valid descriptor indexes */
>  	u8	boReceiveUncorrectInfo;	/* important settings in beacon/probe resp. have been changed */
>  	u8	NoOfJoinerInIbss;
> @@ -238,7 +228,7 @@ struct wb_local_para {
>  	 */
>  	u8	JoinerInIbss[(MAX_BSS_DESCRIPT_ELEMENT + 3) & ~0x03];
>  
> -/* General Statistics, count at Rx_handler or Tx_callback interrupt handler */
> +	/* General Statistics, count at Rx_handler or Tx_callback interrupt handler */
>  	u64	GS_XMIT_OK;		/* Good Frames Transmitted */
>  	u64	GS_RCV_OK;		/* Good Frames Received */
>  	u32	GS_RCV_ERROR;		/* Frames received with crc error */
> @@ -247,11 +237,11 @@ struct wb_local_para {
>  	u32	GS_XMIT_ONE_COLLISION;	/* one collision */
>  	u32	GS_XMIT_MORE_COLLISIONS;/* more collisions */
>  
> -/*
> - * ================================================================
> - * Statistics (no matter whether it had done successfully) -wkchen
> - * ================================================================
> - */
> +	/*
> +	 * ================================================================
> +	 * Statistics (no matter whether it had done successfully) -wkchen
> +	 * ================================================================
> +	 */
>  	u32	_NumRxMSDU;
>  	u32	_NumTxMSDU;
>  	u32	_dot11WEPExcludedCount;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
