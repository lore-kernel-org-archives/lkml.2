Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2JRKbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:31:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45973 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab2JRKbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:31:43 -0400
Date: Thu, 18 Oct 2012 13:31:40 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Ingo Molnar <mingo@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Linux KVM tool for v3.7-rc0
In-Reply-To: <20121018100312.GB14814@gmail.com>
Message-ID: <alpine.LFD.2.02.1210181325460.9682@tux.localdomain>
References: <alpine.LFD.2.02.1210121434140.10531@tux.localdomain> <20121012172736.GA15650@infradead.org> <20121018100312.GB14814@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Ingo Molnar wrote:
> * Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Fri, Oct 12, 2012 at 02:34:33PM +0300, Pekka Enberg wrote:
> > > Hi Linus,
> > > 
> > > Please consider pulling the latest LKVM tree from:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git kvmtool/for-linus
> > > 
> > > LKVM is the long lost userspace friend of KVM that makes it really easy
> > > to launch virtualized Linx environment on x86 and PPC64 Linux.
> > 
> > This still doesn't have any business in the kernel tree. [...]
> 
> Pekka & the LKVM developers are using the tools/kvm/ tree setup 
> to create new kernel features, to improve the kernel and to 
> reuse kernel code, amongst other things.
> 
> So being in the kernel tree is very practical and useful to 
> them.

It's probably not a surprise to anyone that I'm with Ingo on this. It's 
OK if people don't think tools/kvm is *worth it* but claiming that living 
in a separate repository is just as easy is completely ignoring reality.

			Pekka
