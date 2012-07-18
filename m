Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2GRHFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:05:07 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40814 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2GRHFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:05:04 -0400
Date: Wed, 18 Jul 2012 09:04:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: david@lang.hm
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
Message-ID: <20120718070458.GA10357@gmail.com>
References: <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
 <20120715211848.GA21167@aftab.osrc.amd.com>
 <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
 <20120716082418.GC24327@aftab.osrc.amd.com>
 <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm>
 <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com>
 <alpine.DEB.2.02.1207161222380.32545@asgard.lang.hm>
 <CA+55aFw7zdyPpDEdpDbYWc-Z++v_kDQHD3Z+-QwPszh+9bU+tQ@mail.gmail.com>
 <alpine.DEB.2.02.1207161451020.32545@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207161451020.32545@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> > Anybody who says "I want to run Fedora without SELINUX 
> > because I do my own security development" is by *definition* 
> > not relevant to the whole feature.
> 
> Don't mistake the example for the feature. the SELINUX thing 
> is just an example. As Alan Cox commented, taking a distro 
> config and disabling one thing is a common troubleshooting 
> request from kernel developers.

It's still irrelevant:

 - if a user chooses a distro config it means that he is using 
   that distro. Disabling an essential component of the distro 
   config, even if a kernel developer asks for it, will likely 
   break that distro and is thus a dumb thing to do. (the
   typical user will also be unlikely to be *able* to edit a 
   .config and make sure it works.)

 - Furthermore, there's *already* over ten thousand select's in 
   our Kconfig's, and it's already hard at times to disable 
   dependent options.

 - I've been using what Linus suggested for many years via 
   private patches to do bootable randconfig testing and the 
   concept works just fine - enabling a distro specific 
   minconfig is absolutely useful, I'm glad it's being pursued 
   upstream as well...

So what you are arguing about is IMO irrelevant, it is 
immaterial to the problem at hand and the concept works just 
fine in practice.

Thanks,

	Ingo
