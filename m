Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430Ab2FZHc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:32:58 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:33738 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352Ab2FZHc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:32:57 -0400
Date: Tue, 26 Jun 2012 09:32:55 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: Remove unused asm/numnodes.h
Message-ID: <20120626073255.GB7866@samfundet.no>
References: <1339174815.30984.8.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339174815.30984.8.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Fri 08 Jun 2012 19:00:15 +0200 or thereabout, Paul Bolle wrote:
> This is handled with config options now.
> 

Yes, but AVR32 doesn't have those bits in arch/avr32/Kconfig, hence removing
the NODES_SHIFT definition will reduce it to 0 in include/Linux/numa.h. I
suspect it is already done...

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Previous, inspirational, patch:
>     30957a8 ("[SPARC64]: Remove unused asm-sparc64/numnodes.h")
> 
> 1) Tested basically like this:
>     $ git grep -n "numnodes\.h"
>     $ git grep -n "define[[:space:]]*NODES_SHIFT\b"
>     arch/avr32/include/asm/numnodes.h:5:#define NODES_SHIFT 2
>     include/linux/numa.h:6:#define NODES_SHIFT     CONFIG_NODES_SHIFT
>     include/linux/numa.h:8:#define NODES_SHIFT     0
>     $
> 
>  arch/avr32/include/asm/numnodes.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>  delete mode 100644 arch/avr32/include/asm/numnodes.h
> 
> diff --git a/arch/avr32/include/asm/numnodes.h b/arch/avr32/include/asm/numnodes.h
> deleted file mode 100644
> index 0b864d7..0000000
> --- a/arch/avr32/include/asm/numnodes.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef __ASM_AVR32_NUMNODES_H
> -#define __ASM_AVR32_NUMNODES_H
> -
> -/* Max 4 nodes */
> -#define NODES_SHIFT	2
> -
> -#endif /* __ASM_AVR32_NUMNODES_H */
-- 
mvh
Hans-Christian Egtvedt
