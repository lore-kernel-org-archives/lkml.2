Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab0LPJ6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:58:51 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:1828 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0LPJ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:58:50 -0500
Date: Thu, 16 Dec 2010 10:58:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <public@hansmi.ch>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove myself from MAINTAINERS as I no longer have the
  hardware to test.
Message-ID: <20101216105838.01dddcd0@endymion.delvare>
In-Reply-To: <20101213104055.GB2188@calypso>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	<1292086307-19211-21-git-send-email-tj@kernel.org>
	<20101211201931.00414518@endymion.delvare>
	<AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
	<20101213101638.GA2188@calypso>
	<20101213111817.1d2087b0@endymion.delvare>
	<20101213104055.GB2188@calypso>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stelian,

On Mon, 13 Dec 2010 11:40:55 +0100, Stelian Pop wrote:
> This driver is PPC only, and I can no longer test it.
> 
> Subject: [PATCH] Remove myself from MAINTAINERS as I no longer have the hardware to test.
> 
> Signed-off-by: Stelian Pop <stelian@popies.net>
> ---
>  MAINTAINERS |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> (...)
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1a1c27b..61d8c41 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -429,7 +429,6 @@ S:	Supported
>  F:	arch/x86/kernel/microcode_amd.c
>  
>  AMS (Apple Motion Sensor) DRIVER
> -M:	Stelian Pop <stelian@popies.net>
>  M:	Michael Hanselmann <linux-kernel@hansmi.ch>
>  S:	Supported
>  F:	drivers/macintosh/ams/

I suggest that you send this patch to Andrew Morton or Benjamin
Herrenschmidt. It doesn't fit in any of my trees so I can't pick it.

Thanks,
-- 
Jean Delvare
