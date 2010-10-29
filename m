Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0J2GMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:12:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54020 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0J2GMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:12:46 -0400
Date: Fri, 29 Oct 2010 08:12:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
Message-ID: <20101029061242.GA31130@merkur.ravnborg.org>
References: <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com> <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com> <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com> <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com> <4CC8ABC7.5030003@suse.cz> <20101028203542.GA30879@merkur.ravnborg.org> <AANLkTimcsAcSgEz7vvVzp11XPvY9f010nCRmBCd9VkfF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimcsAcSgEz7vvVzp11XPvY9f010nCRmBCd9VkfF@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 04:42:13PM -0400, Mike Frysinger wrote:
> On Thu, Oct 28, 2010 at 16:35, Sam Ravnborg wrote:
> > On Thu, Oct 28, 2010 at 12:46:31AM +0200, Michal Marek wrote:
> >> On 27.10.2010 20:23, Mike Frysinger wrote:
> >> > can we get this change dropped from linux-next until someone gets a
> >> > chance to fix it ?
> >>
> >> Sorry I missed this thread. So your last patch
> >> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
> >> failure? Can you submit it with a proper Signed-off-by and changelog?
> >
> > Did you see the patch I posted in: http://lkml.org/lkml/2010/10/19/534
> >
> > The one that fix up the cppflags usage.
> >
> > I think this will solve the issue with blackfin nicely - and
> > make use of cppflags more as expected.
> 
> but then i followed up that the Makefile code exists to strip out
> quotes because the CPP cannot do it for us and we need a value sans
> quotes:
> http://lkml.org/lkml/2010/10/19/538

Yep - but this was only relevant for patch number two.
I would expect the first patch to solve it.

I may look at it in a few weeks time.

	Sam
