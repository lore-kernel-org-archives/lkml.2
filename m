Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GOKRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:17:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2GOKRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <20120715101434.GA18144@aftab.osrc.amd.com>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
	<1342212885.25704.4.camel@lade.trondhjem.org>
	<CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com>
	<20120714103716.GD26559@liondog.tnic>
	<CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com>
	<20120715101434.GA18144@aftab.osrc.amd.com>
Date: Sun, 15 Jul 2012 13:17:16 +0300
X-Google-Sender-Auth: CO04TpeKc8MphLjSnnMgkfccTlM
Message-ID: <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration for
 distro issues
From: Pekka Enberg <penberg@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
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

On Sun, Jul 15, 2012 at 1:14 PM, Borislav Petkov <bp@amd64.org> wrote:
> On Sat, Jul 14, 2012 at 03:12:05PM +0300, Pekka Enberg wrote:
>> We have "make kvmconfig" in the KVM tool tree that pretty much does
>> that automatically. There's nothing tools/kvm specific about it so I
>> guess you could merge that separately.
>
> Yes, something like KVMTOOL_TEST_ENABLE except not a make target but a
> Kconfig option.

It is a config option too - "make kvmconfig" simply enables it.

                        Pekka
