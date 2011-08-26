Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1HZRkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:40:37 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:41484 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752070Ab1HZRke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:40:34 -0400
Date: Fri, 26 Aug 2011 10:40:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 26 (i7core_edac)
Message-Id: <20110826104031.4c5861e5.rdunlap@xenotime.net>
In-Reply-To: <CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
	<205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
	<CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 16:16:11 +0200 Sedat Dilek wrote:

> On Fri, Aug 26, 2011 at 10:07 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > On Thu, August 25, 2011 10:00 pm, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> The powerpc allyesconfig build still fails today.
> >>
> >> Changes since 20110825:
> >
> >
> > on i386:
> >
> > ERROR: "__udivdi3" [drivers/edac/i7core_edac.ko] undefined!
> >
> > in both get_sdram_scrub_rate()
> > and set_sdram_scrub_rate()
> >
> > --
> 
> Hi Randy,
> 
> can you test with the patch attached, please?
> 
> ( UNTESTED, just followed patches like "[PATCH] p54: Use do_div for
> 64-bit division to fix 32-bit kernels" or "[PATCH v1] carl9170: Use
> do_div for 64-bit division to fix 32-bit kernels" )

Yes, this works after I removed the extra right parens in both cases.
(did you test it?)

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
