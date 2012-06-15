Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2FOTZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:25:44 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:41735 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753900Ab2FOTZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:25:43 -0400
Message-ID: <4FDB8C25.4070502@xenotime.net>
Date: Fri, 15 Jun 2012 12:25:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: comedi: fix Kconfig for COMEDI_PCMCIA_DRIVERS
References: <201206150918.55593.hartleys@visionengravers.com>
In-Reply-To: <201206150918.55593.hartleys@visionengravers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2012 09:18 AM, H Hartley Sweeten wrote:

> The depends on PCCARD is redundant. All of the comedi PCMCIA
> drivers depend on PCMCIA which can only be enabled if PCCARD
> is enabled. Remove the extra depends check.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfondation.org>


Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/comedi/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index 848cf7e..2ca7f08 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -1097,7 +1097,7 @@ endif # COMEDI_PCI_DRIVERS
>  
>  menuconfig COMEDI_PCMCIA_DRIVERS
>  	tristate "Comedi PCMCIA drivers"
> -	depends on (PCMCIA || PCCARD)
> +	depends on PCMCIA
>  	---help---
>  	  Enable comedi PCMCIA and PCCARD drivers to be built
>  



-- 
~Randy
