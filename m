Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2GNMMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 08:12:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41202 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2GNMMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120714103716.GD26559@liondog.tnic>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<1342212885.25704.4.camel@lade.trondhjem.org>
	<CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
	<20120714103716.GD26559@liondog.tnic>
Date: Sat, 14 Jul 2012 15:12:05 +0300
X-Google-Sender-Auth: qXrBfyuAALZGN-frWSko3D0uVN8
Message-ID: <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
From: Pekka Enberg <penberg@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2012 at 1:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jul 13, 2012 at 11:41:21PM +0200, richard -rw- weinberger wrote:
>> On Fri, Jul 13, 2012 at 10:54 PM, Myklebust, Trond
>> <Trond.Myklebust@netapp.com> wrote:
>> > We could at least make selection of a minimal set of drivers for the
>> > more common virtualised platforms a lot easier.
>> > Right now, you need to hunt through 30+ different menus in order to find
>> > what you need to run in a basic KVM virtual machine...
>>
>> Yes, every time I build a kernel to be used on KVM I forget something. :-\
>>
>> We could introduce a section in Kconfig which contains selections for
>> common use cases.
>> E.g. as Linus requested for minimal distro requirements but also
>> selections for various common
>> guest configurations.
>
> +1.
>
> Same experience with building a kvm kernel so I couldn't agree more.

We have "make kvmconfig" in the KVM tool tree that pretty much does
that automatically. There's nothing tools/kvm specific about it so I
guess you could merge that separately.

                        Pekka
