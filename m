Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab1GGNT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:19:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1GGNTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:19:55 -0400
Date: Thu, 7 Jul 2011 15:19:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2]drivers:staging:rtl typo fix encryptiong to
 encryption.
In-Reply-To: <1309927897-25404-2-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1107071519380.11049@pobox.suse.cz>
References: <1309927897-25404-1-git-send-email-justinmattock@gmail.com> <1309927897-25404-2-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ staging -- CCing Greg ]

On Tue, 5 Jul 2011, Justin P. Mattock wrote:

> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> The beow patch fixes a typo.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
>  drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> index 6cb31e1..552115c 100644
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c
> @@ -445,7 +445,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb,
>  		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>  			bytes_per_frag -= IEEE80211_FCS_LEN;
>  
> -		/* Each fragment may need to have room for encryptiong pre/postfix */
> +		/* Each fragment may need to have room for encryption pre/postfix */
>  		if (encrypt)
>  			bytes_per_frag -= crypt->ops->extra_prefix_len +
>  				crypt->ops->extra_postfix_len;
> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
> index 995346d..d13be4c 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
> @@ -762,7 +762,7 @@ int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
>  		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>  			bytes_per_frag -= IEEE80211_FCS_LEN;
>  
> -		/* Each fragment may need to have room for encryptiong pre/postfix */
> +		/* Each fragment may need to have room for encryption pre/postfix */
>  		if (encrypt)
>  			bytes_per_frag -= crypt->ops->extra_prefix_len +
>  				crypt->ops->extra_postfix_len;
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
> index ec7845e..59c45a5 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
> @@ -723,7 +723,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
>  		(CFG_IEEE80211_COMPUTE_FCS | CFG_IEEE80211_RESERVE_FCS))
>  			bytes_per_frag -= IEEE80211_FCS_LEN;
>  
> -		/* Each fragment may need to have room for encryptiong pre/postfix */
> +		/* Each fragment may need to have room for encryption pre/postfix */
>  		if (encrypt)
>  			bytes_per_frag -= crypt->ops->extra_prefix_len +
>  				crypt->ops->extra_postfix_len;
> -- 
> 1.7.6
> 

-- 
Jiri Kosina
SUSE Labs
