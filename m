Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0I1SwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:52:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab0I1SwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:52:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cD4icLMZ6AeRjySkI9Ul/ga2v7ySdBgARrnvJep9iNR+0qhXZoAeTVlTwsz+jOV/Er
         e2LCboKVnt3m6FRFKzyJIFwyT9w5ESp6A6iOJuOO7dLxY+B2fPkIZdbGduMCGOUzERHE
         e0tF+yvlTsTlAF8+w15ccSmKaiRWGOvdCK1vU=
Message-ID: <4CA23963.8040409@pobox.com>
Date: Tue, 28 Sep 2010 14:52:19 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] de2104x: remove experimental status
References: <201009282046.21279.linux@rainbow-software.org>
In-Reply-To: <201009282046.21279.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 02:46 PM, Ondrej Zary wrote:
> It should be ready after 8 years...remove the experimental dependency.
>
> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
>
> --- linux-2.6.36-rc3-/drivers/net/tulip/Kconfig	2010-08-29 17:36:04.000000000 +0200
> +++ linux-2.6.36-rc3/drivers/net/tulip/Kconfig	2010-09-28 19:49:46.000000000 +0200
> @@ -11,8 +11,8 @@ menuconfig NET_TULIP
>   if NET_TULIP
>
>   config DE2104X
> -	tristate "Early DECchip Tulip (dc2104x) PCI support (EXPERIMENTAL)"
> -	depends on PCI&&  EXPERIMENTAL
> +	tristate "Early DECchip Tulip (dc2104x) PCI support"
> +	depends on PCI
>   	select CRC32
>   	---help---
>   	  This driver is developed for the SMC EtherPower series Ethernet

Well...  it's not the years, it's the quality...  which I think has been 
sufficiently increased.

Acked-by: Jeff Garzik <jgarzik@redhat.com>


