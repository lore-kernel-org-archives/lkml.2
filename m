Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab1CWM2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:28:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42459 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab1CWM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:28:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=DgKWBOL9KyEHN6jJqiB4+E1D59SeS4Pokmx9GuzUOr0n6MAaBolLc0XTT4DAbDsrqc
         hxc2SnXmd4jY3OThA0N0/kWRvDK+GZ5n9NkdlcLrNRCGaTScXJvAAm5CQEpjfFlzulvs
         fO75wuN94xXLjhUn+gcacME+1GaPJF++5uxe0=
Date: Wed, 23 Mar 2011 20:27:46 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: lizf@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Clean up CodingStyle for scripts/kconfig/gconf.c
Message-ID: <20110323122742.GA8641@gmail.com>
Mail-Followup-To: lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
References: <20110322143839.GA10291@gmail.com>
 <4D894CD0.9030509@cn.fujitsu.com>
 <20110323070017.GA3731@gmail.com>
 <4D89A225.1060701@cn.fujitsu.com>
 <AANLkTik9tv7Qroin6TucgK5HnY8JOhUuTg8uk4PugC0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik9tv7Qroin6TucgK5HnY8JOhUuTg8uk4PugC0c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:20:00PM +0800, jiaweiwei wrote:
> On Wed, Mar 23, 2011 at 3:32 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> >
> > >>> Hi us,
> > >>>     Clean up CodingStyle for scripts/kconfig/gconf.c.
> > >>>
> > >>
> > >> What makes you think this is a bad style? Does Documentation/CodingStyle
> > say
> > >> so? Does checkpatch.pl make a complain? Do you really think this
> > improves
> > >> readability? I don't think so, and actually it makes the code worse.
> > > But we all write '#include <***>'. I have never seen '#  include <***>'.
> >
> > Then let's see:
> >
> > $ find -name '*.c' -exec grep -H '^# .*include' {} \;
> > ./drivers/char/mem.c:# include <linux/efi.h>
> > ./drivers/char/random.c:# include <linux/irq.h>
> > ./drivers/scsi/nsp32.c:# include "nsp32_debug.c"
> > ./drivers/video/epson1355fb.c:#  include <mach/hardware.h>
> >
Okay, i see.
> > You can look into those cases, and then you should be able to figure out
> > why.
> >
> > >>
> > >> Run checkpatch.pl on this file, and you'll see lots of errors and
> > warnings,
> > >> but pure codingstyle cleanup is rarely worth anything, so better don't
> > do
> > >> that.
> > > I am sorry, I have not got your meaning clearly.
> >
> > Codingstyle cleanups aren't worth your time, and it would be better for you
> > and for the kernel project as a whole if you can find something more
> > valuable
> > to work on.
Thanks, i will try my best.

Best Regards.
Harry Wei.
> >
> > >>
> > >>> Thanks.
> > >>> Best Regards.
> > >>> Harry Wei.
> > >>>
> > >>> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > >>> ---
> > >>>  scripts/kconfig/gconf.c |    2 +-
> > >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >>>
> > >>> diff --git a/scripts/kconfig/gconf.c b/scripts/kconfig/gconf.c
> > >>> index 4558961..56da945 100644
> > >>> --- a/scripts/kconfig/gconf.c
> > >>> +++ b/scripts/kconfig/gconf.c
> > >>> @@ -7,7 +7,7 @@
> > >>>   */
> > >>>
> > >>>  #ifdef HAVE_CONFIG_H
> > >>> -#  include <config.h>
> > >>> +#include <config.h>
> > >>>  #endif
> > >>>
> > >>>  #include "lkc.h"
> >
> 
> 
> 
> -- 
>  do kernel
