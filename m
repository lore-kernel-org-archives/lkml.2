Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2DKRL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 13:11:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2DKRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 13:11:25 -0400
Date: Wed, 11 Apr 2012 10:11:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: drop obsolete ARCH_BOOTMEM support
Message-ID: <20120411171115.GE12887@google.com>
References: <20120406124735.GA6920@merkur.ravnborg.org>
 <20120411163016.GC12887@google.com>
 <CAE9FiQVmyTSUGKmusrVvj-38URhRFzvjv7w-2ch928kEiJPOhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVmyTSUGKmusrVvj-38URhRFzvjv7w-2ch928kEiJPOhg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:03:50AM -0700, Yinghai Lu wrote:
> On Wed, Apr 11, 2012 at 9:30 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Fri, Apr 06, 2012 at 02:47:35PM +0200, Sam Ravnborg wrote:
> >> From ae6cdc767f973f39cb205af4b80ff13f35a1b66e Mon Sep 17 00:00:00 2001
> >> From: Sam Ravnborg <sam@ravnborg.org>
> >> Date: Fri, 6 Apr 2012 13:37:08 +0200
> >> Subject: [PATCH] x86: drop obsolete ARCH_BOOTMEM support
> >>
> >> x86 unconditionally uses NO_BOOTMEM so there is no use
> >> of the HAVE_ARCH_BOOTMEM support as mm/bootmem.c is the
> >> only file referencing this symbol.
> >>
> >> bootmem_arch_preferred_node() is the function referred
> >> in the mm/bootmem.c code and can thuis be dropped too.
> >>
> >> x86 was the sole user of HAVE_ARCH_BOOTMEM - so there is
> >> an opportunity to clean up a little in mm/bootmem.c too
> >> if we do not expect other users to emerge.
> >
> > avr32 seems to have it too?
> 
> avr32 is:
> 
> config HAVE_ARCH_BOOTMEM
>         def_bool n
> 
> so that is not used with avr32

Yeah, then better remove the reference from there too, right?

Thanks.

-- 
tejun
