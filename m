Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1JNN0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 09:26:10 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:35314 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753813Ab1JNN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 09:26:08 -0400
Message-ID: <4E98385D.4000508@st.com>
Date: Fri, 14 Oct 2011 15:25:49 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/21] stmmac: drop unused Kconfig symbol
References: <1318595432.6132.76.camel@x61.thuisdomein>
In-Reply-To: <1318595432.6132.76.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul

IIRC, I had posted a patch to do this long time ago.
In any case, the dual mac Kconfig is not useful and it can be removed.

Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

On 10/14/2011 2:30 PM, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  drivers/net/stmmac/Kconfig |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/stmmac/Kconfig b/drivers/net/stmmac/Kconfig
> index 7df7df4..9e37a9a 100644
> --- a/drivers/net/stmmac/Kconfig
> +++ b/drivers/net/stmmac/Kconfig
> @@ -20,15 +20,6 @@ config STMMAC_DA
>  	  By default, the DMA arbitration scheme is based on Round-robin
>  	  (rx:tx priority is 1:1).
>  
> -config STMMAC_DUAL_MAC
> -	bool "STMMAC: dual mac support (EXPERIMENTAL)"
> -	default n
> -        depends on EXPERIMENTAL && STMMAC_ETH && !STMMAC_TIMER
> -	help
> -	  Some ST SoCs (for example the stx7141 and stx7200c2) have two
> -	  Ethernet Controllers. This option turns on the second Ethernet
> -	  device on this kind of platforms.
> -
>  config STMMAC_TIMER
>  	bool "STMMAC Timer optimisation"
>  	default n

