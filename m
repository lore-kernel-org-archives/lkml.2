Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab1EYMwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:52:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207Ab1EYMww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:52:52 -0400
Date: Wed, 25 May 2011 14:52:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: (Short?) merge window reminder
In-Reply-To: <4DDC2236.6010608@mit.edu>
Message-ID: <alpine.LRH.2.00.1105251447000.1874@twin.jikos.cz>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com> <20110523192056.GC23629@elte.hu> <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com> <4DDC2236.6010608@mit.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Andy Lutomirski wrote:

> Also, when someone in my lab installs <insert ancient enterprise distro 
> here> on a box that's running software I wrote that needs to support 
> modern high-speed peripherals, then I can say "What?  You seriously 
> expect this stuff to work on Linux 2007?  Let's install a slightly less 
> stable distro from at least 2010."  This sounds a lot less nerdy than 
> "What?  You seriously expect this stuff to work on Linux 2.6.27?  Let's 
> install a slightly less stable distro that uses at least 2.6.36."

I hate to jump into this excellent example of bike-shedding discussion, 
but anyway ...

Your example doesn't really reflect reality.

It's common for older enterprise distributions to gradually incorporate a 
lot of backported code (and most importantly new hardware support 
code/drivers) while not upgrading the kernel major version. So yes, you 
will in reality get 2.6.16 kernel (at least according to uname) with 
libata with newer service packs of SLES 10, for example (and you could 
find many of those across distributions).

-- 
Jiri Kosina
SUSE Labs

