Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab0CZPT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:19:57 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:48671 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab0CZPT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=PxkKHbPIoLm98mohDa4mAw9JFfv5VBkAlOSyqitCBpcLklWIw1qt5LpZycZLjcLQJk
         jNqMdsF7PJ0zQFb6KSWYGx5iQGWCCGaW5PHRxqXLZ6VOx3GVPi1RiDCsL/qY0MsfSNuC
         oPkRn6KtnkcNfSTubdEyFTvjVpQqQoYuw1yaM=
Date: Fri, 26 Mar 2010 18:19:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx_s.h Coding style fixes.
Message-ID: <20100326151942.GB20225@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1269615817-3565-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269615817-3565-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 04:03:37PM +0100, Lars Lindley wrote:
> I fixed all reported checkpatch issues.
> I also removed versioning comments.
> I checked for oopses with Dan Carpenters strip_whitespace.pl
> and diff.
> 
> Signed-off-by: <lindley@coyote.org>

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

> ---
>  drivers/staging/winbond/wb35tx_s.h |   62 ++++++++++++++++++-----------------
>  1 files changed, 32 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
> index f70f433..6799048 100644
> --- a/drivers/staging/winbond/wb35tx_s.h
> +++ b/drivers/staging/winbond/wb35tx_s.h
> @@ -3,45 +3,47 @@
>  
>  #include "mds_s.h"
>  
> -//====================================
> -// IS89C35 Tx related definition
> -//====================================
> -#define TX_INTERFACE			0	// Interface 1
> -#define TX_PIPE					3	// endpoint 4
> -#define TX_INTERRUPT			1	// endpoint 2
> -#define MAX_INTERRUPT_LENGTH	64	// It must be 64 for EP2 hardware
> -
> -
> -
> -//====================================
> -// Internal variable for module
> -//====================================
> -
> -
> +/*
> + * ====================================
> + * IS89C35 Tx related definition
> + * ====================================
> + */
> +#define TX_INTERFACE		0	/* Interface 1 */
> +#define TX_PIPE			3	/* endpoint 4 */
> +#define TX_INTERRUPT		1	/* endpoint 2 */
> +#define MAX_INTERRUPT_LENGTH	64	/* It must be 64 for EP2 hardware */
> +
> +
> +
> +/*
> + * ====================================
> + * Internal variable for module
> + * ====================================
> + */
>  struct wb35_tx {
> -	// For Tx buffer
> -	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
> +	/* For Tx buffer */
> +	u8		TxBuffer[MAX_USB_TX_BUFFER_NUMBER][MAX_USB_TX_BUFFER];
>  
> -	// For Interrupt pipe
> -	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
> +	/* For Interrupt pipe */
> +	u8		EP2_buf[MAX_INTERRUPT_LENGTH];
>  
> -	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
> -	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
> -	u32			ByteTransfer;
> +	atomic_t	TxResultCount; /* For thread control of EP2 */
> +	atomic_t	TxFireCounter; /* For thread control of EP4 */
> +	u32		ByteTransfer;
>  
> -	u32	    TxSendIndex;// The next index of Mds array to be sent
> -	u32	    EP2vm_state; // for EP2vm state
> -	u32	    EP4vm_state; // for EP4vm state
> -	u32	    tx_halt; // Stopping VM
> +	u32		TxSendIndex;/* The next index of Mds array to be sent */
> +	u32		EP2vm_state; /* for EP2vm state */
> +	u32		EP4vm_state; /* for EP4vm state */
> +	u32		tx_halt; /* Stopping VM */
>  
> -	struct urb *				Tx4Urb;
> -	struct urb *				Tx2Urb;
> +	struct urb	*Tx4Urb;
> +	struct urb	*Tx2Urb;
>  
>  	int		EP2VM_status;
>  	int		EP4VM_status;
>  
> -	u32	TxFillCount; // 20060928
> -	u32	TxTimer; // 20060928 Add if sending packet not great than 13
> +	u32		TxFillCount;
> +	u32		TxTimer; /* Add if sending packet not great than 13 */
>  };
>  
>  #endif
> -- 
> 1.7.0.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
