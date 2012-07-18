Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2GRJNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:13:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34668 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GRJN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:13:29 -0400
Date: Wed, 18 Jul 2012 11:13:13 +0200
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
Message-ID: <20120718091313.GA13085@gmail.com>
References: <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm>
 <20120716082418.GC24327@aftab.osrc.amd.com>
 <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm>
 <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com>
 <alpine.DEB.2.02.1207161222380.32545@asgard.lang.hm>
 <CA+55aFw7zdyPpDEdpDbYWc-Z++v_kDQHD3Z+-QwPszh+9bU+tQ@mail.gmail.com>
 <alpine.DEB.2.02.1207161451020.32545@asgard.lang.hm>
 <20120718070458.GA10357@gmail.com>
 <alpine.DEB.2.02.1207180133540.20176@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207180133540.20176@asgard.lang.hm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* david@lang.hm <david@lang.hm> wrote:

> On Wed, 18 Jul 2012, Ingo Molnar wrote:
> 
> >* david@lang.hm <david@lang.hm> wrote:
> >
> >>>Anybody who says "I want to run Fedora without SELINUX
> >>>because I do my own security development" is by *definition*
> >>>not relevant to the whole feature.
> >>
> >>Don't mistake the example for the feature. the SELINUX thing
> >>is just an example. As Alan Cox commented, taking a distro
> >>config and disabling one thing is a common troubleshooting
> >>request from kernel developers.
> >
> >It's still irrelevant:
> >
> >- if a user chooses a distro config it means that he is using
> >  that distro. Disabling an essential component of the distro
> >  config, even if a kernel developer asks for it, will likely
> >  break that distro and is thus a dumb thing to do. (the
> >  typical user will also be unlikely to be *able* to edit a
> >  .config and make sure it works.)
> 
> that's assuming that everything listed really is essential.

See the requirements in Linus's earlier mail:

------------->

The *two* requirements (and they're really the same theme) I
personally think we should have for this are

 - I think every single "select" for these things should come 
with a comment about what it is about and why the distro needs 
it (to show there was some thought involved and not just a blind 
"took it from the distro config")

 - It should be about *minimal* settings. I'd rather have too 
few things and the occasional complaint about "oh, it didn't 
work because it missed XYZ" than have it grow to contain all the 
options just because somebody decided to just add random things 
until things worked.

<-------------

Thanks,

	Ingo
