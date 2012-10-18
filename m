Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2JRKDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:03:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34383 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2JRKDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:03:21 -0400
Date: Thu, 18 Oct 2012 12:03:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
Message-ID: <20121018100312.GB14814@gmail.com>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain>
 <20121012172736.GA15650@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012172736.GA15650@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Oct 12, 2012 at 02:34:33PM +0300, Pekka Enberg wrote:
> > Hi Linus,
> > 
> > Please consider pulling the latest LKVM tree from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus
> > 
> > LKVM is the long lost userspace friend of KVM that makes it really easy
> > to launch virtualized Linx environment on x86 and PPC64 Linux.
> 
> This still doesn't have any business in the kernel tree. [...]

Pekka & the LKVM developers are using the tools/kvm/ tree setup 
to create new kernel features, to improve the kernel and to 
reuse kernel code, amongst other things.

So being in the kernel tree is very practical and useful to 
them.

It's also *very* useful to kernel developers like me, and I wish 
all of user-space tooling was as easy to use and as well working 
as 'vm run':

I'm using 'vm' regularly for quick kernel testing: I just want 
something that just works and reuses the existing distro 
user-space environment unintrusively. In that sense it's very 
handy, 'vm' will in essence boot the well-maintained system. Not 
some stale old disk image. Not a second system I need to 
maintain. I'd not be using it if it didn't came integrated via 
tools/ and integrated into the kernel. 'make kvmconfig' and the 
other bits of practical kernel development integration are very 
useful and just work as well.

The fact that it's not useful to you (yet?) that does not 
invalidate the utility of this project to those to whom it *is* 
useful. No argument you ever outlined here invalidates the plain 
utility of this project.

Whether you think that it "has no place in the kernel" is 
completely irrelevant - what matters is actual utility to 
people:

If Linus thinks that the upsides are not convincing enough (yet, 
or ever), that's obviously enough reason for him to not pull it 
- but that does not stop this project from being useful to those 
who *are* using it to improve and test the kernel.

Thanks,

	Ingo
