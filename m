Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037Ab1KDAui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:50:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1KDAuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:50:37 -0400
Date: Thu, 3 Nov 2011 17:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>,
        "Neo Jia" <cyclonusj@gmail.com>, <levinsasha928@gmail.com>,
        "JeremyFitzhardinge" <jeremy@goop.org>, <linux-mm@kvack.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Seth Jennings" <sjenning@linux.vnet.ibm.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <ngupta@vflare.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-Id: <20111103175410.b15efb8c.akpm@linux-foundation.org>
In-Reply-To: <4EB2D427020000780005ED64@nat28.tlf.novell.com>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<4EB2D427020000780005ED64@nat28.tlf.novell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Nov 2011 16:49:27 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 27.10.11 at 20:52, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > Hi Linus --
> > 
> > Frontswap now has FOUR users: Two already merged in-tree (zcache
> > and Xen) and two still in development but in public git trees
> > (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
> > changes required to support transcendent memory; part 1 was cleancache
> > which you merged at 3.0 (and which now has FIVE users).
> > 
> > Frontswap patches have been in linux-next since June 3 (with zero
> > changes since Sep 22).  First posted to lkml in June 2009, frontswap 
> > is now at version 11 and has incorporated feedback from a wide range
> > of kernel developers.  For a good overview, see
> >    http://lwn.net/Articles/454795.
> > If further rationale is needed, please see the end of this email
> > for more info.
> > 
> > SO... Please pull:
> > 
> > git://oss.oracle.com/git/djm/tmem.git #tmem
> > 
> >...
> > Linux kernel distros incorporating frontswap:
> > - Oracle UEK 2.6.39 Beta:
> >    http://oss.oracle.com/git/?p=linux-2.6-unbreakable-beta.git;a=summary 
> > - OpenSuSE since 11.2 (2009) [see mm/tmem-xen.c]
> >    http://kernel.opensuse.org/cgit/kernel/ 
> 
> I've been away so I am too far behind to read this entire
> very long thread, but wanted to confirm that we've been
> carrying an earlier version of this code as indicated above
> and it would simplify our kernel maintenance if frontswap
> got merged.  So please count me as supporting frontswap.

Are you able to tell use *why* you're carrying it, and what benefit it
is providing to your users?

