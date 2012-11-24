Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831Ab2KXIfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:35:50 -0500
Received: from fep23.mx.upcmail.net ([62.179.121.43]:46268 "EHLO
	fep23.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab2KXIft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:35:49 -0500
X-Greylist: delayed 1021 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2012 03:35:49 EST
X-SourceIP: 84.242.78.234
From: Pavel Pisa <ppisa@pikron.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Re: [PATCH 18/24] MAINTAINERS: remove drivers/mmc/host/imxmmc.*
Date: Sat, 24 Nov 2012 09:18:42 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net> <1353716808-16375-19-git-send-email-cesarb@cesarb.net>
In-Reply-To: <1353716808-16375-19-git-send-email-cesarb@cesarb.net>
Organization: PiKRON Ltd.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201211240918.42930.ppisa@pikron.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 24 November 2012 01:26:42 Cesar Eduardo Barros wrote:
> This driver was removed by commit 6187fee (mmc: remove imxmmc driver).
>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Pavel Pisa <ppisa@pikron.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fc646ef..cac8e49 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4905,12 +4905,6 @@ F:	Documentation/video4linux/meye.txt
>  F:	drivers/media/pci/meye/
>  F:	include/uapi/linux/meye.h
>
> -MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
> -M:	Pavel Pisa <ppisa@pikron.com>
> -L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -S:	Maintained
> -F:	drivers/mmc/host/imxmmc.*
> -
>  MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
>  M:	Jiri Slaby <jirislaby@gmail.com>
>  S:	Maintained

Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz>

I have still the hardware but have lack resources to keep with current
kernel development for that old HW. We plan to switch to newer i.MX
hardware - hopefully with more bug free MMC/SD support, because MX1
has taken me yer a year of fighting with its bugs (on Linux and RTEMS
as well).

Best wishes,


                Pavel Pisa
    e-mail:     pisa@cmp.felk.cvut.cz
    www:        http://cmp.felk.cvut.cz/~pisa
    university: http://dce.fel.cvut.cz/
    company:    http://www.pikron.com/
