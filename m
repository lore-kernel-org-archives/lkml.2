Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0JNETN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:19:13 -0400
Received: from void.printf.net ([89.145.121.20]:36516 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab0JNETL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:19:11 -0400
Date: Thu, 14 Oct 2010 05:19:04 +0100
From: Chris Ball <cjb@laptop.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        MM <mirq-linux@rere.qmqm.pl>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next] mmc: fix cb710 kconfig dependency warning
Message-ID: <20101014041904.GF3553@void.printf.net>
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101013181519.6ff00e10.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Oct 13, 2010 at 06:15:19PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/mmc/host/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
> +++ linux-next-20101013/drivers/mmc/host/Kconfig
> @@ -394,7 +394,7 @@ config MMC_TMIO
>  
>  config MMC_CB710
>  	tristate "ENE CB710 MMC/SD Interface support"
> -	depends on PCI
> +	depends on PCI && MISC_DEVICES
>  	select CB710_CORE
>  	help
>  	  This option enables support for MMC/SD part of ENE CB710/720 Flash

Thanks very much, pushed to mmc-next.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
