Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab0ENODu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:03:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37554 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab0ENODs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=Ca15Pl+d4CASvXgZQbVKEUbC1aRAwGnMCF2OQ0eVXolDh8T3Jh/DHj0XO5KF4Gj4iW
         6AlbJGrrNwtYu+mdhj6pC7aqiw77D3UAwdWOkYP+hFCLJxpMjh8ct80JxnCpi3A4f/dz
         aOtVzgC7WpoXzclPkw1gR60wPv7lU1Nj6sG80=
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] vlynq: make whole Kconfig-menu dependant on architecture
Date: Fri, 14 May 2010 16:05:01 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-server; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eugene Konev <ejka@imfi.kspu.ru>
References: <1273844445-15508-1-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1273844445-15508-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005141605.01692.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010 15:40:45 Wolfram Sang wrote:
> This removes an empty menu for most platforms.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Florian Fainelli <florian@openwrt.org>

> ---
> 
>  drivers/vlynq/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vlynq/Kconfig b/drivers/vlynq/Kconfig
> index a9efb16..d874b4f 100644
> --- a/drivers/vlynq/Kconfig
> +++ b/drivers/vlynq/Kconfig
> @@ -1,8 +1,8 @@
>  menu "TI VLYNQ"
> +	depends on AR7 && EXPERIMENTAL
> 
>  config VLYNQ
>  	bool "TI VLYNQ bus support"
> -	depends on AR7 && EXPERIMENTAL
>  	help
>  	  Support for Texas Instruments(R) VLYNQ bus.
>  	  The VLYNQ bus is a high-speed, serial and packetized
