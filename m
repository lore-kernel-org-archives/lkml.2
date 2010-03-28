Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab0C1MB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 08:01:56 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60695 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754131Ab0C1MBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 08:01:55 -0400
Date: Sun, 28 Mar 2010 14:01:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35tx_f.h Coding style fixes.
Message-ID: <20100328120144.GC1406@ucw.cz>
References: <1269759475-4920-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269759475-4920-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2010-03-28 08:57:55, Lars Lindley wrote:
> I fixed the checkpatch.pl problems and converted the function
> arguments away from CamelCase and hungarian notation.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

ack.

> ---
>  drivers/staging/winbond/wb35tx_f.h |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/winbond/wb35tx_f.h b/drivers/staging/winbond/wb35tx_f.h
> index a7af9cb..1d3b515 100644
> --- a/drivers/staging/winbond/wb35tx_f.h
> +++ b/drivers/staging/winbond/wb35tx_f.h
> @@ -4,18 +4,20 @@
>  #include "core.h"
>  #include "wbhal_f.h"
>  
> -//====================================
> -// Interface function declare
> -//====================================
> -unsigned char Wb35Tx_initial(	 struct hw_data * pHwData );
> -void Wb35Tx_destroy(  struct hw_data * pHwData );
> -unsigned char Wb35Tx_get_tx_buffer(  struct hw_data * pHwData,  u8 **pBuffer );
> +/*
> + * ====================================
> + * Interface function declare
> + * ====================================
> + */
> +unsigned char Wb35Tx_initial(struct hw_data *hw_data);
> +void Wb35Tx_destroy(struct hw_data *hw_data);
> +unsigned char Wb35Tx_get_tx_buffer(struct hw_data *hw_data, u8 **buffer);
>  
>  void Wb35Tx_EP2VM_start(struct wbsoft_priv *adapter);
>  
>  void Wb35Tx_start(struct wbsoft_priv *adapter);
> -void Wb35Tx_stop(  struct hw_data * pHwData );
> +void Wb35Tx_stop(struct hw_data *hw_data);
>  
> -void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter,  u32 TimeCount);
> +void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 time_count);
>  
>  #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
