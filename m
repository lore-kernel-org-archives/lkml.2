Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1GIIIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 04:08:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55447 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1GIIId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 04:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <1310160851-26415-1-git-send-email-james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
	<1310160851-26415-1-git-send-email-james_p_freyensee@linux.intel.com>
Date: Sat, 9 Jul 2011 10:08:32 +0200
X-Google-Sender-Auth: 1d6kCQuRZI0OysZDE9BFJ_0BRaI
Message-ID: <CAMuHMdV5OC6ENMK9uOXZBv3Z3MrOMiu0P6az5baM9jdRFwSAvA@mail.gmail.com>
Subject: Re: [PATCH] PTI implicit declaration fix.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: james_p_freyensee@linux.intel.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        randy.dunlap@oracle.com, sfr@canb.auug.org.au,
        christophe.guerard@intel.com, pranav.k.sanghadia@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 23:34,  <james_p_freyensee@linux.intel.com> wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
>
> In a certain compile configuration, functions like
> 'kmalloc' and 'copy_from_user' were coming up as
> implicit errors.  This patch adds slab.h and
> uaccess.h to the driver.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Please don't add "Acked-by" lines before people have ack'ed your patches.

> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  drivers/misc/pti.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
> index 8653bd0..4ba4e5f 100644
> --- a/drivers/misc/pti.c
> +++ b/drivers/misc/pti.c
> @@ -22,6 +22,8 @@
>  */
>
>  #include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/console.h>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
