Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab1DZQsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:48:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20099 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1DZQsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:48:21 -0400
Date: Tue, 26 Apr 2011 09:47:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, joe@perches.com,
        randy.dunlap@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH]Remove a warning
Message-Id: <20110426094723.a127116e.randy.dunlap@oracle.com>
In-Reply-To: <20110426043835.GA4154@gmail.com>
References: <20110426043835.GA4154@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB6F72E.0033:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 12:38:37 +0800 Harry Wei wrote:

> Hi us,
>    When i was compiling kernel, a warning happened to me.
> The warning said like following.
> 
> drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from 
> incompatible pointer type
> 
> So i patched like this.
> 
> From: Harry Wei <harryxiyou@gmail.com>
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.


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


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
