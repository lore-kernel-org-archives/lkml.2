Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1BWJsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:48:12 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49251 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab1BWJsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oPICtgfI/gMKKEfB6uhbKVKTjY5whdIhpfbEz5t2OU8CnO8sAzIjsVqoB6MSQYcn6/
         2/yTLGd9KTMdJ12oKU9O5WpDVmJKjD/Q3MIqKJ5xK/GQ3vLR6RhwUUHP3rVAwJlFoKZm
         /Ep2oxOW0VmP9K01ltgKZ8RrekrgXf5my1WWM=
Date: Wed, 23 Feb 2011 17:48:00 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] MAINTAINERS: Quote non-alphanumeric email
 addresses
Message-ID: <20110223094757.GE3090@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <cover.1298439175.git.joe@perches.com>
 <70a2035a61c95dfa12a3eeb9b16433ced527d886.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a2035a61c95dfa12a3eeb9b16433ced527d886.1298439175.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:42:02PM -0800, Joe Perches wrote:
> Add quotes around email address with periods and commas.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a9d971e..3508c0f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1052,7 +1052,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  
>  ARM/TETON BGA MACHINE SUPPORT
> -M:	Mark F. Brown <mark.brown314@gmail.com>
> +M:	"Mark F. Brown" <mark.brown314@gmail.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:	Maintained
>  
> @@ -1456,7 +1456,7 @@ F:	drivers/mtd/devices/block2mtd.c
>  
>  BLUETOOTH DRIVERS
>  M:	Marcel Holtmann <marcel@holtmann.org>
> -M:	Gustavo F. Padovan <padovan@profusion.mobi>
> +M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
>  L:	linux-bluetooth@vger.kernel.org
>  W:	http://www.bluez.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> @@ -1465,7 +1465,7 @@ F:	drivers/bluetooth/
>  
>  BLUETOOTH SUBSYSTEM
>  M:	Marcel Holtmann <marcel@holtmann.org>
> -M:	Gustavo F. Padovan <padovan@profusion.mobi>
> +M:	"Gustavo F. Padovan" <padovan@profusion.mobi>
>  L:	linux-bluetooth@vger.kernel.org
>  W:	http://www.bluez.org/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git
> @@ -2913,7 +2913,7 @@ F:	Documentation/blockdev/cpqarray.txt
>  F:	drivers/block/cpqarray.*
>  
>  HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
> -M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
> +M:	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
>  L:	iss_storagedev@hp.com
>  S:	Supported
>  F:	Documentation/scsi/hpsa.txt
> @@ -4201,7 +4201,7 @@ F:	Documentation/serial/moxa-smartio
>  F:	drivers/char/mxser.*
>  
>  MSI LAPTOP SUPPORT
> -M:	Lee, Chun-Yi <jlee@novell.com>
> +M:	"Lee, Chun-Yi" <jlee@novell.com>
>  L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/msi-laptop.c
> -- 
> 1.7.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
