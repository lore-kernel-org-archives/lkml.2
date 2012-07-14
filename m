Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2GNKhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 06:37:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53132 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab2GNKhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 06:37:20 -0400
Date: Sat, 14 Jul 2012 12:37:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120714103716.GD26559@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	"Myklebust, Trond" <Trond.Myklebust@netapp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
	Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
	Debian Kernel Team <debian-kernel@lists.debian.org>,
	OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
 <1342212885.25704.4.camel@lade.trondhjem.org>
 <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 11:41:21PM +0200, richard -rw- weinberger wrote:
> On Fri, Jul 13, 2012 at 10:54 PM, Myklebust, Trond
> <Trond.Myklebust@netapp.com> wrote:
> > We could at least make selection of a minimal set of drivers for the
> > more common virtualised platforms a lot easier.
> > Right now, you need to hunt through 30+ different menus in order to find
> > what you need to run in a basic KVM virtual machine...
> 
> Yes, every time I build a kernel to be used on KVM I forget something. :-\
> 
> We could introduce a section in Kconfig which contains selections for
> common use cases.
> E.g. as Linus requested for minimal distro requirements but also
> selections for various common
> guest configurations.

+1.

Same experience with building a kvm kernel so I couldn't agree more.

Thanks.

-- 
Regards/Gruss,
    Boris.
