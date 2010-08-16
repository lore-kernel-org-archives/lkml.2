Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0HPUsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:48:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60939 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285Ab0HPUsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:48:46 -0400
MIME-Version: 1.0
In-Reply-To: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
References: <1281947514-25319-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Aug 2010 14:48:23 -0600
X-Google-Sender-Auth: 1t1xwfNKT0j_p5-Fv9kmNwWDrl0
Message-ID: <AANLkTinHh3xa3+pj1ZZTMYaRykG7fDgTZjmF2QY6RVTU@mail.gmail.com>
Subject: Re: [PATCH] microblaze: Fixup function of/address cleaning
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 2:31 AM, Michal Simek <monstr@monstr.eu> wrote:
> Commit 22ae782f86b726f9cea752c0f269ff6dcdf2f6e1
> anccidentaly removed linux/of_address.h header.
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

As mentioned in my reply to your other email, I'm trying to get
includes of linux/of*.h out of prom.h and into the C files that
actually need them.  If you send me the failing .config, then I'll
happily take care of fixing it up.  :-)

Cheers,
g.

> ---
>  arch/microblaze/include/asm/prom.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
> index 5012b22..66894b5 100644
> --- a/arch/microblaze/include/asm/prom.h
> +++ b/arch/microblaze/include/asm/prom.h
> @@ -22,7 +22,6 @@
>  #include <linux/types.h>
>  #include <asm/irq.h>
>  #include <asm/atomic.h>
> -#include <linux/of_address.h>
>
>  #define HAVE_ARCH_DEVTREE_FIXUPS
>
> @@ -90,6 +89,7 @@ extern int of_irq_map_pci(struct pci_dev *pdev, struct of_irq *out_irq);
>  * by this file, but there are a bunch of .c files that currently depend
>  * on it.  Eventually they will be cleaned up. */
>  #include <linux/of_fdt.h>
> +#include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/platform_device.h>
>
> --
> 1.5.5.6
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
