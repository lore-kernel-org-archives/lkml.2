Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1J2Kiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 06:38:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59250 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab1J2Kiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 06:38:51 -0400
Date: Sat, 29 Oct 2011 12:38:43 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, devicetree-discuss@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: include errno.h
Message-ID: <20111029103843.GC20132@ponder.secretlab.ca>
References: <20111006124044.1066.7111.stgit@localhost6.localdomain6>
 <CAMuHMdX-V6FqSZ_mmPm5aW_bTUNMk4sz5cADryX3Xyk627wRdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdX-V6FqSZ_mmPm5aW_bTUNMk4sz5cADryX3Xyk627wRdg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 10:38:16AM +0200, Geert Uytterhoeven wrote:
> On Thu, Oct 6, 2011 at 14:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > When compiling ath6kl for beagleboard (omap2plus_defconfig plus
> > CONFIG_ATH6KL, CONFIG_OF disable) with current linux-next compilation
> > fails:
> >
> > include/linux/of.h:269: error: 'ENOSYS' undeclared (first use in this function)
> > include/linux/of.h:276: error: 'ENOSYS' undeclared (first use in this function)
> > include/linux/of.h:289: error: 'ENOSYS' undeclared (first use in this function)
> 
> And now this build failure (also on m68k) has hit Linus' tree, more
> than 3 weeks after
> its detection in -next...
> 
> > Fix this by including errno.h from of.h.
> >
> > Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Appied, thanks, and I'll push out to Linus as soon as the test build finishes.

g.

> 
> > ---
> >  include/linux/of.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/of.h b/include/linux/of.h
> > index 9180dc5..219c29d 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -17,6 +17,7 @@
> >  */
> >  #include <linux/types.h>
> >  #include <linux/bitops.h>
> > +#include <linux/errno.h>
> >  #include <linux/kref.h>
> >  #include <linux/mod_devicetable.h>
> >  #include <linux/spinlock.h>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
