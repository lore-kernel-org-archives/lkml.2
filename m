Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab1KVROP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:14:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591Ab1KVROO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:14:14 -0500
Date: Tue, 22 Nov 2011 18:14:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] sound: Kconfig: drop unknown symbol
 ARCH_CLPS7500
In-Reply-To: <1321963622.18752.1.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111221813320.28728@pobox.suse.cz>
References: <1321963622.18752.1.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Paul Bolle wrote:

> Commit 635f0258e5 ("[ARM] clps7500: remove support") missed one instance
> of the ARCH_CLPS7500 Kconfig symbol. Drop it now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  sound/oss/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
> index 6c9e8e8..5849b12 100644
> --- a/sound/oss/Kconfig
> +++ b/sound/oss/Kconfig
> @@ -521,7 +521,7 @@ config SC6600_CDROMBASE
>  
>  config SOUND_VIDC
>  	tristate "VIDC 16-bit sound"
> -	depends on ARM && (ARCH_ACORN || ARCH_CLPS7500)
> +	depends on ARM && ARCH_ACORN
>  	help
>  	  16-bit support for the VIDC onboard sound hardware found on Acorn
>  	  machines.

While you are at it, there is one more reference to this symbol (in 
comments) in drivers/net/ethernet/cirrus/cs89x0.c

-- 
Jiri Kosina
SUSE Labs
