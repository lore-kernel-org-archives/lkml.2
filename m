Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1KBDZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 23:25:59 -0400
Received: from ozlabs.org ([203.10.76.45]:56589 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1KBDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PULL] virtio
In-Reply-To: <20111101124223.GA14060@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au> <20111101114542.GA13434@redhat.com> <1320150813.3847.24.camel@lappy> <20111101124223.GA14060@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 02 Nov 2011 11:39:12 +1030
Message-ID: <8739e7uy87.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Nov 2011 14:42:23 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, Nov 01, 2011 at 02:33:33PM +0200, Sasha Levin wrote:
> > A proper solution would be for example a configuration in the PIO config
> > space which points to the MMIO BAR to use instead.
> 
> I think it makes sense to put the configuration in PCI
> configuration space, using vendor-specific capability.
> This way we can reuse existing functionality for scanning
> capability lists.

Patch welcome; first one to implement it becomes virtio PCI maintainer!
I'll keep maintaining the spec, since it covers much more than the PCI
mechanics, but everything I know about PCI I learn from these
discussions.

Meanwhile, I've dropped this patch; mea culpa.

> > Unless Michael pointed this patch out, it would have broken (at least)
> > the kvm tool in a non obvious way which would require a rather long
> > session of 'git bisect' to figure out whats wrong.

I assumed not, until QEMU provided the second BAR it would simply fall
back.  Or am I completely misunderstanding?

Thanks,
Rusty.
