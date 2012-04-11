Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761101Ab2DKTr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:47:58 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:60489 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761093Ab2DKTr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:47:57 -0400
Date: Wed, 11 Apr 2012 21:47:51 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        plagnioj@jcrosoft.com, Josh.wu@atmel.com,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: remove non-responding web link for
 atmel_usba driver
Message-ID: <20120411194751.GA7055@samfundet.no>
References: <cover.1334137680.git.nicolas.ferre@atmel.com>
 <05cc973152bedd39bf37fa1222960c2a2c438500.1334137680.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05cc973152bedd39bf37fa1222960c2a2c438500.1334137680.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 11 Apr 2012 13:54:46 +0200 or thereabout, Nicolas Ferre wrote:
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> ---
>  MAINTAINERS |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index be04d43..cde4008 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1379,7 +1379,6 @@ F:	drivers/input/touchscreen/atmel_tsadcc.c
>  ATMEL USBA UDC DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@atmel.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> -W:	http://avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver
>  S:	Supported
>  F:	drivers/usb/gadget/atmel_usba_udc.*

FWIW, I'm mirroring the old contents of avr32linux.org, it will eventually
reappear on mirror.egtvedt.no/avr32linux.org, for the URL above it'll be
http://mirror.egtvedt.no/avr32linux.org/twiki/bin/view/Main/AtmelUsbDeviceDriver

I'll get graphics and attached files do download when I have completed the
initial mirroring.

With regards to this specific driver, I am unsure how much information the
wiki really gives, it is probably out of sync as well now...

-- 
mvh
Hans-Christian Egtvedt
