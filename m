Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1HUWg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 18:36:27 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22463 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1HUWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 18:36:25 -0400
Date: Mon, 22 Aug 2011 00:37:05 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Arnaud Lacombe <lacombar@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
In-Reply-To: <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1108220033240.8284@swampdragon.chaosbits.net>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Aug 2011, Arnaud Lacombe wrote:

> Hi,
> 
> On Fri, Aug 19, 2011 at 7:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Reposting due to popular demand. Several other people are running
> > into the same problem with all kinds of software.
> >
> > Only change is rebase against current master.
> >
> FWIW, couldn't this be made a boot option ?
> 
> That might help some distros, say Fedora, who actually ships
> 2.6.40+x-branded kernels, or allow people to use no longer supported
> distros with recent kernels.
> 
> About this last point, once functional, I intend to upgrade my trixbox
> install (based on 2.6.18) to a 3.x-ish kernel, that might be fun...
> 

Just a random thought.
Since this is purely to be backwards compatible with binary only software 
that makes bad assumptions about the kernel version (as far as I can 
tell at least), shouldn't we make it explicit from the beginning that this 
will have a limited life time by adding it to 
Documentation/feature-removal-schedule.txt with a removal date at 
somewhere soon(ish) like 3.6 (or something) at day one?
I can't imaging we'd want to support something like this forever going 
forward... or..?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

