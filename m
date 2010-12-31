Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab0LaPdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 10:33:32 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52488 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab0LaPda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 10:33:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Yaak/nIPWN6UQ1tGLC8lGLc3ZPY2LsMEyPUxZTRUx+v8s2rUD6rlc5fMte/dHRoifv
         OSkXNBYkBlqWR3BZLvI8i3E/lExTAvWslp+LR6BEK+Rrr4WOQAQAihLwVvB+h+JduiO6
         fYPpPQ/aqb1q6O1RamAjSIk3hqJmtr4ZeAKAw=
Message-ID: <4D1DF7CA.8040504@lwfinger.net>
Date: Fri, 31 Dec 2010 09:33:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 07/15]drivers:net:wireless:iwlwifi Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com> <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 05:07 PM, Justin P. Mattock wrote:
> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-ict.c |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c     |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-core.c    |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
> index a5dbfea..b5cb3be 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
> @@ -197,7 +197,7 @@ static irqreturn_t iwl_isr(int irq, void *data)
>  
>   none:
>  	/* re-enable interrupts here since we don't have anything to service. */
> -	/* only Re-enable if diabled by irq  and no schedules tasklet. */
> +	/* only Re-enable if disabled by irq  and no schedules tasklet. */
>  	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->_agn.inta)
>  		iwl_enable_interrupts(priv);
>  
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index c2636a7..9b912c0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1316,7 +1316,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
>  	}
>  
>  	/* Re-enable all interrupts */
> -	/* only Re-enable if diabled by irq */
> +	/* only Re-enable if disabled by irq */
>  	if (test_bit(STATUS_INT_ENABLED, &priv->status))
>  		iwl_enable_interrupts(priv);
>  
> @@ -1530,7 +1530,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
>  	}
>  
>  	/* Re-enable all interrupts */
> -	/* only Re-enable if diabled by irq */
> +	/* only Re-enable if disabled by irq */
>  	if (test_bit(STATUS_INT_ENABLED, &priv->status))
>  		iwl_enable_interrupts(priv);
>  }
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 25fb391..8700ab3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -1304,7 +1304,7 @@ irqreturn_t iwl_isr_legacy(int irq, void *data)
>  
>   none:
>  	/* re-enable interrupts here since we don't have anything to service. */
> -	/* only Re-enable if diabled by irq */
> +	/* only Re-enable if disabled by irq */
>  	if (test_bit(STATUS_INT_ENABLED, &priv->status))
>  		iwl_enable_interrupts(priv);
>  	spin_unlock_irqrestore(&priv->lock, flags);

