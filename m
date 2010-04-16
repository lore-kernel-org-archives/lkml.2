Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0DPLsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:48:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:57024 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0DPLsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:48:37 -0400
Date: Fri, 16 Apr 2010 13:48:30 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jakob Viketoft <jakob.viketoft@bitsim.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: #include corrections
Message-ID: <20100416114830.GO30801@buzzloop.caiaq.de>
References: <4BC84DEC.2000806@bitsim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC84DEC.2000806@bitsim.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:45:48PM +0200, Jakob Viketoft wrote:
> The use of mfp_cfg_t causes build errors without including
> <mach/mfp.h>. The include for the ax88796 is kicked as well since
> it's inclusion is obsoleted as adviced by Daniel Mack.

Argh, I'm sorry. This time, I was too fast. The ax88796 must stay, I
overlooked the use of ax_plat_data.

Daniel

> CC: stable@kernel.org
> CC: Daniel Mack <daniel@caiaq.de>
> CC: Eric Miao <eric.y.miao@gmail.com>
> Signed-off-by Jakob Viketoft <jakob.viketoft@bitsim.com>

> --- a/arch/arm/mach-pxa/include/mach/colibri.h	2010-03-15
> 17:09:39.000000000 +0100
> +++ b/arch/arm/mach-pxa/include/mach/colibri.h	2010-04-16
> 13:30:43.000000000 +0200
> @@ -1,7 +1,7 @@
>  #ifndef _COLIBRI_H_
>  #define _COLIBRI_H_
> 
> -#include <net/ax88796.h>
> +#include <mach/mfp.h>
> 
>  /*
>   * common settings for all modules
> 
