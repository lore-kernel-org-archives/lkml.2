Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab0LVOWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:22:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51038 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0LVOWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:22:16 -0500
Date: Wed, 22 Dec 2010 08:33:52 -0600
From: David Sin <davidsin@ti.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, Greg KH <greg@kroah.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/9] TI DMM-TILER driver
Message-ID: <20101222143350.GA27503@lba0869738>
References: <1291674446-10766-1-git-send-email-davidsin@ti.com>
 <20101216172531.GG29435@lba0869738>
 <20101216173737.GA6767@lba0869738>
 <201012161843.48262.arnd@arndb.de>
 <20101216190207.GC6767@lba0869738>
 <AANLkTikZwm45Mkj_A=zzULeGBuYpLyP9N1bSJSFWegWV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZwm45Mkj_A=zzULeGBuYpLyP9N1bSJSFWegWV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 09:28:07AM +1000, Dave Airlie wrote:
> On Fri, Dec 17, 2010 at 5:02 AM, David Sin <davidsin@ti.com> wrote:
> I get the impression with the ARM graphics, that you just have a lot
> of separate drivers for separate IP blocks all providing some misc
> random interfaces to userspace where some binary driver binds all the
> functionality together into a useful whole, which seems like a really
> bad design.
> 
> Generally on x86, the tiling hw is part of the GPU and is exposed as
> part of a coherent GPU driver.
> 
> I'm just wonder what the use-cases for this tiler are and what open
> apps can use it for?
> 
> Dave.
Yes -- on the omap4 soc, the dmm-tiler hw block is separate from the 
gpu.  I've had some, but not much, past discusions on hw designs 
where graphics/video related ip blocks are part of the same core.  It's 
a good point that you bring up and it certainly makes sense to me.  
I will bring it up with some omap hw folks that I know, and see if 
something that can be considered in future omap versions.
 
Some of the use-cases are HD video decoding and encoding.  Also, 
hi-res image capture -- I believe 12MP or greater.  OpenMax IL components 
and other multimedia frameworks can allocate video memory 
through a user space tiler library.  Thanks for your comments, Dave.  
-- 
David Sin
