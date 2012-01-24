Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2AXXld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:41:33 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16912 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2AXXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:41:32 -0500
Date: Wed, 25 Jan 2012 00:41:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] thermal_sys: Remove unnecessary line continuations
In-Reply-To: <4afc2738bbc7690440312921d8ae8ddf0e14e2dc.1327447797.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1201250040420.27508@swampdragon.chaosbits.net>
References: <cover.1327447797.git.joe@perches.com> <4afc2738bbc7690440312921d8ae8ddf0e14e2dc.1327447797.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Joe Perches wrote:

> Line continations are not necessary in function calls
> or statements.  Remove them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/thermal/thermal_sys.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index dd9a574..7326baa 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -283,8 +283,7 @@ passive_show(struct device *dev, struct device_attribute *attr,
>  static DEVICE_ATTR(type, 0444, type_show, NULL);
>  static DEVICE_ATTR(temp, 0444, temp_show, NULL);
>  static DEVICE_ATTR(mode, 0644, mode_show, mode_store);
> -static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, \
> -		   passive_store);
> +static DEVICE_ATTR(passive, S_IRUGO | S_IWUSR, passive_show, passive_store);
>  
>  static struct device_attribute trip_point_attrs[] = {
>  	__ATTR(trip_point_0_type, 0444, trip_point_type_show, NULL),
> @@ -1314,8 +1313,8 @@ int generate_netlink_event(u32 orig, enum events event)
>  	int result;
>  
>  	/* allocate memory */
> -	size = nla_total_size(sizeof(struct thermal_genl_event)) + \
> -				nla_total_size(0);
> +	size = nla_total_size(sizeof(struct thermal_genl_event)) +
> +	       nla_total_size(0);
>  
>  	skb = genlmsg_new(size, GFP_ATOMIC);
>  	if (!skb)
> @@ -1331,8 +1330,8 @@ int generate_netlink_event(u32 orig, enum events event)
>  	}
>  
>  	/* fill the data */
> -	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT, \
> -			sizeof(struct thermal_genl_event));
> +	attr = nla_reserve(skb, THERMAL_GENL_ATTR_EVENT,
> +			   sizeof(struct thermal_genl_event));
>  
>  	if (!attr) {
>  		nlmsg_free(skb);
> 

Yes.
Reviewed-by: Jesper Juhl <jj@chaosbits.net>



-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

