Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab2GNSvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 14:51:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48011 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2GNSvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 14:51:24 -0400
Date: Sat, 14 Jul 2012 22:51:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120714185120.GC4093@moon>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
 <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
 <20120714124332.GA4093@moon>
 <20120714174827.GA13319@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120714174827.GA13319@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 07:48:27PM +0200, Borislav Petkov wrote:
> On Sat, Jul 14, 2012 at 04:43:32PM +0400, Cyrill Gorcunov wrote:
> > For example to enable "PCI driver for virtio devices" I need to go to
> > Device Drivers -> Virtio drivers, while I think it would be great to
> > have everything virt. related in Virtualization section.
> 
> Actually, we need something more generic than that: everything X-related
> should be automatically selected when setting CONFIG_X. And X can be any
> subset of configuration options which belong to one feature, be it KVM,
> distro-specific stuff, or CPU-vendor specific stuff, or whatever.
> 
> I can imagine, for example, that when a user wants to have an
> AMD-specific config, it automatically selects CPU_SUP_AMD, X86_MCE_AMD
> (for MCE), MICROCODE_AMD (microcode support), AGP_AMD64, EDAC_AMD64 and
> a bunch of other AMD-specific features.

sure, no doubts, it would be great! (I must admit I never looked up into
kconfig parser code so i don't know if this could be achieved easily).

	Cyrill
