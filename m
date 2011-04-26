Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1DZHIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:08:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34226 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab1DZHIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XwLjQ+9zOgZ8memm1z5SDJ9m02XDBx0I4v3yQyw6PtLof9I4/yTqMYY7at02JaymVN
         Eca8/7mIE/Y7+afQxL2sKsfoIDSbaxZZAmEMqtmUHmHr9oG7f+TCD4cnjzCxd4NUHm94
         D3ptx+59K/Ecc2Ss9nhKrrSHiOSLGDq7I+kZ0=
Date: Tue, 26 Apr 2011 15:07:56 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, akpm@linux-foundation.org, joe@perches.com,
        randy.dunlap@oracle.com
Subject: Re: [PATCH]Remove a warning
Message-ID: <20110426070754.GB4154@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	akpm@linux-foundation.org, joe@perches.com, randy.dunlap@oracle.com
References: <20110426043835.GA4154@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426043835.GA4154@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:38:37PM +0800, Harry Wei wrote:
> Hi us,
>    When i was compiling kernel, a warning happened to me.
> The warning said like following.
> 
> drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from 
> incompatible pointer type
See http://s1202.photobucket.com/albums/bb364/harrywei/?action=view&current=patched2.png
for more details.
> 
> So i patched like this.
> 
> From: Harry Wei <harryxiyou@gmail.com>
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
> index 6a71f52..7637839 100644
> --- a/drivers/staging/wlan-ng/cfg80211.c
> +++ b/drivers/staging/wlan-ng/cfg80211.c
> @@ -273,7 +273,7 @@ exit:
>  }
>  
>  int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
> -			   u8 key_index)
> +			   u8 key_index, bool unicast, bool multicast)
>  {
>  	wlandevice_t *wlandev = dev->ml_priv;
>  
> -- 
> 1.7.0.4
> 
> 
> 
