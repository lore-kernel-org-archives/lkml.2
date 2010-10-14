Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0JNT1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:27:23 -0400
Received: from void.printf.net ([89.145.121.20]:35764 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528Ab0JNT1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:27:22 -0400
Date: Thu, 14 Oct 2010 20:27:17 +0100
From: Chris Ball <cjb@laptop.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH -next v2] mmc: fix cb710 kconfig dependency warning
Message-ID: <20101014192717.GA19966@void.printf.net>
References: <20101013181519.6ff00e10.randy.dunlap@oracle.com> <20101014090442.GA14454@rere.qmqm.pl> <4CB74C5F.4000905@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB74C5F.4000905@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 14, 2010 at 11:30:55AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kconfig dependency warning to satisfy dependencies:
> 
> warning: (MMC_CB710 && MMC && PCI) selects CB710_CORE which has unmet direct dependencies (MISC_DEVICES && PCI)
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <mirq-linux@rere.qmqm.pl>
> ---
>  drivers/mmc/host/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20101013.orig/drivers/mmc/host/Kconfig
> +++ linux-next-20101013/drivers/mmc/host/Kconfig
> @@ -395,6 +395,7 @@ config MMC_TMIO
>  config MMC_CB710
>  	tristate "ENE CB710 MMC/SD Interface support"
>  	depends on PCI
> +	select MISC_DEVICES
>  	select CB710_CORE
>  	help
>  	  This option enables support for MMC/SD part of ENE CB710/720 Flash
> --

Thanks, carrying this version in mmc-next now.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
