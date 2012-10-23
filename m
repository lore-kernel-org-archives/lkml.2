Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032Ab2JWWut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:50:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41436 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab2JWWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <876260hl0p.fsf@octavius.laptop.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-71-git-send-email-keescook@chromium.org>
	<876260hl0p.fsf@octavius.laptop.org>
Date: Tue, 23 Oct 2012 15:50:43 -0700
X-Google-Sender-Auth: sAc6Eg6ww0MtbjeLsN8YSmaMAG4
Message-ID: <CAGXu5j+vCw-oA=Uyw6v3-O1d6itTJ7LEU6DLAEMXL1QDQP_uYA@mail.gmail.com>
Subject: Re: [PATCH 070/193] drivers/mmc/core: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:38 PM, Chris Ball <cjb@laptop.org> wrote:
> On Tue, Oct 23 2012, Kees Cook wrote:
> > This config item has not carried much meaning for a while now and is
> > almost always enabled by default. As agreed during the Linux kernel
> > summit, remove it.
> >
> > CC: Chris Ball <cjb@laptop.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/mmc/core/Kconfig |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> > index ef10387..269d072 100644
> > --- a/drivers/mmc/core/Kconfig
> > +++ b/drivers/mmc/core/Kconfig
> > @@ -18,8 +18,7 @@ config MMC_UNSAFE_RESUME
> >         module parameter "removable=0" or "removable=1".
> >
> >  config MMC_CLKGATE
> > -     bool "MMC host clock gating (EXPERIMENTAL)"
> > -     depends on EXPERIMENTAL
> > +     bool "MMC host clock gating"
> >       help
> >         This will attempt to aggressively gate the clock to the MMC card.
> >         This is done to save power due to gating off the logic and bus
>
> Maybe this isn't important, but:
>
> I think the commit message should be changed -- this part of the series
> doesn't remove EXPERIMENTAL, it removes the dependency on it from its
> current users.  The way the commit message is worded makes it sound like
> the patch is going to remove MMC_CLKGATE, which of course it doesn't.
>
> Ditto the subject line, could be ": remove use of CONFIG_EXPERIMENTAL".

I'll update the commit and subjects for the series; good idea.

> Regardless, for this and the subsequent [071] patch:
>
> Acked-by: Chris Ball <cjb@laptop.org>
>
> (Let me know if you'd like me to take these, I don't mind who merges them.)

Either way is fine; I'm already carrying a bunch, so I'm happy to add
these to that list.

-Kees

--
Kees Cook
Chrome OS Security
