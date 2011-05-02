Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab1EBPXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:23:50 -0400
Received: from kroah.org ([198.145.64.141]:42391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510Ab1EBPXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:23:47 -0400
Date: Mon, 2 May 2011 08:23:37 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, joe@perches.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH]Remove a warning for drivers/staging/wlan-ng/cfg80211.c
Message-ID: <20110502152337.GA7364@kroah.com>
References: <20110502143845.GA4952@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502143845.GA4952@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 10:38:49PM +0800, Harry Wei wrote:
> From: Harry Wei <harryxiyou@gmail.com>
>   
> 	When i was compiling kernel, a warning happened to me.
>   The warning said like following.
> 
> drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from
> incompatible pointer type.
> 
> See http://s1202.photobucket.com/albums/bb364/harrywei/?action=view&current=patched2.png
> for more details.
> 
> So i patch like following.
> 
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c |    2 +-

I'm pretty sure this was included in the set of patches sent to Linux
last week, right?

thanks,

greg k-h
