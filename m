Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab1HUXPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:15:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46420 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab1HUXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:15:44 -0400
Date: Mon, 22 Aug 2011 01:15:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110821231544.GM25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com> <alpine.LNX.2.00.1108220033240.8284@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1108220033240.8284@swampdragon.chaosbits.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:37:05AM +0200, Jesper Juhl wrote:
> On Sun, 21 Aug 2011, Arnaud Lacombe wrote:
> 
> > Hi,
> > 
> > On Fri, Aug 19, 2011 at 7:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >
> > > Reposting due to popular demand. Several other people are running
> > > into the same problem with all kinds of software.
> > >
> > > Only change is rebase against current master.
> > >
> > FWIW, couldn't this be made a boot option ?
> > 
> > That might help some distros, say Fedora, who actually ships
> > 2.6.40+x-branded kernels, or allow people to use no longer supported
> > distros with recent kernels.
> > 
> > About this last point, once functional, I intend to upgrade my trixbox
> > install (based on 2.6.18) to a 3.x-ish kernel, that might be fun...
> > 
> 
> Just a random thought.
> Since this is purely to be backwards compatible with binary only software 
> that makes bad assumptions about the kernel version (as far as I can 

Believe it or not, even users of programs with source do not necessarily
want or are able to to patch the program and recompile.

Also binary compatibility is important. It's one of the things
that made Linux successfull.

> tell at least), shouldn't we make it explicit from the beginning that this 
> will have a limited life time by adding it to 

No.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
