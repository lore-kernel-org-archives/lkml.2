Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab2LGPmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:42:45 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38360 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755348Ab2LGPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:42:44 -0500
Message-ID: <1354894964.29937.38.camel@joe-AO722>
Subject: Re: [PATCH v2 00/14] printk() fixes, optimizations, and clean ups
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "\"Jan H." =?ISO-8859-1?Q?Sch=F6nherr=22?= 
	<schnhrr@cs.tu-berlin.de>,
        Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Sylvain Munaut <s.munaut@whatever-company.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Fri, 07 Dec 2012 07:42:44 -0800
In-Reply-To: <20121207150448.GC20369@kroah.com>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <20121206133907.37c255e9.akpm@linux-foundation.org>
	 <1354837050.22463.4.camel@joe-AO722>
	 <20121206161943.78633125.akpm@linux-foundation.org>
	 <1354848669.22463.23.camel@joe-AO722> <50C1D758.1080007@cs.tu-berlin.de>
	 <20121207150448.GC20369@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 07:04 -0800, Greg Kroah-Hartman wrote:
> On Fri, Dec 07, 2012 at 12:47:36PM +0100, "Jan H. Schönherr" wrote:
> > Am 07.12.2012 03:51, schrieb Joe Perches:
> > > On Thu, 2012-12-06 at 16:19 -0800, Andrew Morton wrote:
> > >> On Thu, 06 Dec 2012 15:37:30 -0800
> > >> Joe Perches <joe@perches.com> wrote:
> > >>> Can you please pick this up for -next now and I'll
> > >>> redo my patches against -next for -rc1 so I'm not
> > >>> delayed until 3.9?
> > >>
> > >> It would be better to do things in the other order.
> > >>
> > >> a) Your patches perform mainly code-movement which doesn't cause
> > >>    functional changes.  Jan's patches are functional changes which
> > >>    require more thought and testing and possible fixups.
> > > 
> > > Fine by me.  Jan?
> > 
> > No problem.
> > 
> > I agree with Andrew, that patches 9 to 14 could use indeed some
> > more eyeballs.
> > 
> > Patches 1 to 8 are more straight-forward, and I would consider
> > these ready. However, they are also those, where I probably won't
> > have any trouble rebasing them on top of your changes.
> > 
> > Anyway. Until now I always thought my patches will end up in the
> > queue of some maintainer, so that I don't have to bother about
> > _when_ posting my patches. Therefore: when should I repost a
> > version rebased on top of Joe's changes?
> 
> You are correct, I'll end up queuing these up to my tree when 3.8-rc1 is
> out,

Andrew suggested I send my patches at -rc2.

> they will live in linux-next until 3.8-final is out, and then go to
> Linus for 3.9-rc1.  Right now, my trees are frozen due to the merge
> window about to open up.  Your patience is appreciated.

I think it'd be easier for a single downstream
maintainer to coordinate these patch sets sequencing.

You or Andrew might be better than you and Andrew.

There is a small patch to printk that should likely
be applied in some form for -rc1 or earlier:

Sylvain Munaut's (cc'd) print_time fix:
https://patchwork.kernel.org/patch/1845971/

I don't know of anything else that likely will
or should be applied before -rc1.

Frederic Weisbecker (also cc'd) has a printk nohz
patch series that merits some consideration too.
https://lkml.org/lkml/2012/10/20/94
https://lkml.org/lkml/2012/11/14/646
I don't know if Ingo pulled it in somewhere or not.

cheers, Joe

