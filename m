Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab2GMWrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:47:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:55002 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2GMWrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:47:14 -0400
Date: Fri, 13 Jul 2012 15:46:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jesper Juhl <jj@chaosbits.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <alpine.LNX.2.00.1207140014070.10676@swampdragon.chaosbits.net>
Message-ID: <alpine.DEB.2.02.1207131544370.32545@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <alpine.LNX.2.00.1207140014070.10676@swampdragon.chaosbits.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2012, Jesper Juhl wrote:

> We are going to end up with a million+ (or something like that) "config
> <RANDOM_FOO_DISTRO>" options that are going to have to be kept up-to-date
> regularly...
> Do we really want that?
> Maybe we do, maybe we don't - I'm not saying anything either way - just
> pointing it out.
>
> I like the general idea - let a user pick the "make my distro work" option
> and then tweak from there. But, with hundreds (thousands?) of distroes out
> there, is it realy doable? Will we be able to keep things updated
> properly?

this needs to be more like 'make install' where the build system doesn't 
have specifics for every distro, but instead refrences a separate file 
that's provided in the same place by every distro, ideally separate from 
the kernel itself.

David Lang
