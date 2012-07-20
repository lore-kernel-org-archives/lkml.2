Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2GTCpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:45:42 -0400
Received: from mail.lang.hm ([64.81.33.126]:55809 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab2GTCpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:45:39 -0400
Date: Thu, 19 Jul 2012 19:44:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ben Hutchings <ben@decadent.org.uk>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <20120719211357.GZ1894@decadent.org.uk>
Message-ID: <alpine.DEB.2.02.1207191942250.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <20120713210240.GG1707@redhat.com> <CA+55aFz_Vv899eXz6F0jtFH=hT4QpB0_2XuS8HySPjHC6s+L7Q@mail.gmail.com> <20120719152618.GD16873@home.goodmis.org> <20120719154521.GC8469@zod.bos.redhat.com>
 <1342714088.12353.33.camel@gandalf.stny.rr.com> <20120719171918.GD8469@zod.bos.redhat.com> <20120719183047.69de3e19@pyramind.ukuu.org.uk> <20120719211357.GZ1894@decadent.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2012, Ben Hutchings wrote:

> On Thu, Jul 19, 2012 at 06:30:47PM +0100, Alan Cox wrote:
>>
>> For the end user case you need the distro to plonk the right file in the
>> right place and be done with it, once they do that the rest is
>> bikeshedding a ten line Makefile rule.
>
> This might work well for future releases; is there not a need to
> make this work for past releases too?

This approach can work for any 3.x kernel version with any distro. The 
distro provides the file, with a new kernel version you do "make 
distconfig', with something prior to when this is added you do 'cp 
/etc/kconfig/filename .config ; make oldconfig' instead.

the make oldconfig papers over a LOT of differences between the kernel 
that the distro built with and the kernel the user is trying to compile.

David Lang
