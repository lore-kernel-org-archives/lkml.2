Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0CRRM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:12:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34760 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0CRRMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:12:52 -0400
Message-ID: <4BA254BC.6090507@cs.helsinki.fi>
Date: Thu, 18 Mar 2010 18:28:44 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
References: <1268927857-14141-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268927857-14141-1-git-send-email-lindley@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> I fixed all problems found by checkpatch.pl and removed CamelCase
> from argument names.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/mlmetxrx_f.h |   27 ++++++++++++++-------------
>  1 files changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mlmetxrx_f.h b/drivers/staging/winbond/mlmetxrx_f.h
> index 6c04e3e..02dfd46 100644
> --- a/drivers/staging/winbond/mlmetxrx_f.h
> +++ b/drivers/staging/winbond/mlmetxrx_f.h
> @@ -1,25 +1,26 @@
> -//================================================================
> -// MLMETxRx.H --
> -//
> -//   Functions defined in MLMETxRx.c.
> -//
> -// Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
> -//================================================================
> +/* ================================================================
> + * MLMETxRx.H --
> + *
> + *   Functions defined in MLMETxRx.c.
> + *
> + * Copyright (c) 2002 Winbond Electrics Corp. All Rights Reserved.
> + * ================================================================
> + */
>  #ifndef _MLMETXRX_H
>  #define _MLMETXRX_H
>  
>  #include "core.h"
>  
> -void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes);
> +void MLME_GetNextPacket(struct wbsoft_priv *adapter,
> +			struct wb35_descriptor *pdes);

Can we get rid of the "p" prefix (hungarian notation) while at it?

>  u8 MLMESendFrame(struct wbsoft_priv *adapter,
> -		 u8 * pMMPDU, u16 len, u8 DataType);
> +		 u8 *pmmpdu, u16 len, u8 datatype);
>  
> -void
> -MLME_SendComplete(struct wbsoft_priv *adapter, u8 PacketID,
> -		  unsigned char SendOK);
> +void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packetid,
> +			unsigned char sendok);
>  
>  #ifdef _IBSS_BEACON_SEQ_STICK_
> -s8 SendBCNullData(struct wbsoft_priv *adapter, u16 wIdx);
> +s8 SendBCNullData(struct wbsoft_priv *adapter, u16 widx);
>  #endif
>  
>  #endif

