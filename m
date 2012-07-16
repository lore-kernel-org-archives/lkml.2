Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2GPT1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:27:34 -0400
Received: from mail.lang.hm ([64.81.33.126]:47629 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab2GPT1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:27:31 -0400
Date: Mon, 16 Jul 2012 12:26:09 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Borislav Petkov <bp@amd64.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
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
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
In-Reply-To: <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1207161222380.32545@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120715101434.GA18144@aftab.osrc.amd.com> <CAOJsxLGBCQ6C-3M0ZdTfVPqnmOKqUE9+78Mhf+67TksmVojuuQ@mail.gmail.com> <20120715211848.GA21167@aftab.osrc.amd.com> <20120715214819.GA1990@moon>
 <alpine.DEB.2.02.1207151459480.20176@asgard.lang.hm> <20120716082418.GC24327@aftab.osrc.amd.com> <alpine.DEB.2.02.1207160937330.20176@asgard.lang.hm> <CA+55aFwwmMbFr4HXTFxF_MeM_n8bfiXfPPgCALTOc1HvidVt1Q@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Linus Torvalds wrote:

> On Mon, Jul 16, 2012 at 9:43 AM,  <david@lang.hm> wrote:
>>
>> The problem is that you can't select the Fedora profile and then unselect
>> SELINUX, so the profile will do you no good.
>
> Guys, stop it now.
>
> Your "problem" isn't what any sane person cares about, and isn't what
> I started the RFC for.
>
> Seriously. NOBODY CARES.
>
> You can do what you want to do *today*. Just edit the config file, or
> use any of the millions of config tools. Stop whining.
>
> The thing I'm asking for is for normal people. Make it easy for people
> who DO NOT CARE about the config file to just build a kernel for their
> machine.
>
> Don't complicate the issue by bringing up some totally unrelated
> question. Don't derail a useful feature for the 99% because you're not
> in it.

Some of the proposed ways to implement the minimum distro kernel would not 
allow you to override the distro defaults because they would be 
implemented by setting dependancies, not by selecting options that you as 
the user could then unselect.

If you have to edit the .config file, and then have your next make *config 
override your edits (due to dependancy resolution) and so have to edit the 
.config file again this is a really ugly way of working.

David Lang
