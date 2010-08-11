Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0HKXSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:18:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302Ab0HKXSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:18:14 -0400
Subject: Re: asm/vga.h (was: Re: drm: Add support for platform devices to
 register as DRM devices)
From: Dave Airlie <airlied@redhat.com>
To: Adam Jackson <ajax@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-arch@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
In-Reply-To: <1281477066.17843.3015.camel@atropine>
References: <AANLkTik44qbia+7w9=83cboTMLbvQDcH-60dHuAnd9ax@mail.gmail.com>
	 <1281477066.17843.3015.camel@atropine>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 09:17:58 +1000
Message-ID: <1281568678.4765.10.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-10 at 17:51 -0400, Adam Jackson wrote:
> On Tue, 2010-08-10 at 22:35 +0200, Geert Uytterhoeven wrote:
> 
> > Now, do we really need <asm/vga.h>? It seems I can make it build and boot using:
> > 

I think we can drop asm/vga.h on all platforms, I'll queue a patch up
for drm-next to see if we hit any problems, it works on x86 at least.

Dave.

> > --- a/include/linux/vgaarb.h
> > +++ b/include/linux/vgaarb.h
> > @@ -31,7 +31,9 @@
> >  #ifndef LINUX_VGA_H
> >  #define LINUX_VGA_H
> > 
> > +#ifdef CONFIG_VGA_ARB
> >  #include <asm/vga.h>
> > +#endif
> > 
> >  /* Legacy VGA regions */
> >  #define VGA_RSRC_NONE         0x00
> 
> That seems fine.
> 
> - ajax
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


