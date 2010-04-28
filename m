Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0D1Sh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:37:26 -0400
Received: from kroah.org ([198.145.64.141]:38318 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab0D1Sgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:36:51 -0400
Date: Wed, 28 Apr 2010 11:27:43 -0700
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH 10/13] drivers/staging/rtl8192u: Hoist assign from if
Message-ID: <20100428182743.GE8509@kroah.com>
References: <cover.1269493047.git.joe@perches.com>
 <150c0791a005720797262c296005ee1bbe8a326f.1269493047.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150c0791a005720797262c296005ee1bbe8a326f.1269493047.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:17:04PM -0700, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> index 27d9257..01e56f6 100644
> --- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
> @@ -1712,7 +1712,8 @@ ieee80211_rx_auth_rq(struct ieee80211_device *ieee, struct sk_buff *skb)
>  	//IEEE80211DMESG("Rx probe");
>  	ieee->softmac_stats.rx_auth_rq++;
>  
> -	if ((status = auth_rq_parse(skb, dest))!= -1){
> +	status = auth_rq_parse(skb, dest);
> +	if (status!= -1) {

again...
