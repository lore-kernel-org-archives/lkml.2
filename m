Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2GMWWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:22:55 -0400
Received: from mail.lang.hm ([64.81.33.126]:57604 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab2GMWWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:22:53 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2012 18:22:53 EDT
Date: Fri, 13 Jul 2012 15:13:46 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Casey Schaufler <casey@schaufler-ca.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
In-Reply-To: <CA+55aFyD_=aMoYKBocWFXXZ7RypWhZemOLyqC4p7oqfDRinqDQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1207131507530.32545@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <50009051.3060806@schaufler-ca.com> <CA+55aFyD_=aMoYKBocWFXXZ7RypWhZemOLyqC4p7oqfDRinqDQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Linus Torvalds wrote:

> On Fri, Jul 13, 2012 at 2:17 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>>
>> Oh dear. I would expect Fedora to say that they require SELinux,
>> thereby making it unusable by anyone doing LSM development.
>
> Oh, *absolutely*.
>
> These options would *not* be meant for people doing odd things and
> experienting with configs.
>
> If you do that, then you might *start* by saying "I want this distro"
> to get the initial guesstimate of the config file you want, but then
> edit the .config by hand later (and remove the "I want all the Fedora
> requirements" option, of course).
>
> This is explicitly and exclusively for normal users. The whole point
> of "expert configurator for special cases" should not be given any
> thought at all - those kinds of people should simply answer "No" to
> the "Do you want the distro basic kconfig requirements" question.

hopefully this can be made a little easier.

more of a 'enable anything set in this file, then give me control again so 
I can turn things off' rather than having to manually edit the .config 
file.

If this is done as a hard set of dependancy settings, it will be very 
annoying for people who for any reason want to disable something that the 
distro considers 'essential'.

I also _really_ like the idea of being able to have a vmware option that 
enables the minimum devices that are needed to run.

Having these be hard dependancies also seems like it would make 
interactions between these sorts of things much more likely to cause 
problems.

If however they are one-shot "go through this file and enable anything 
that it says to turn on" things that then let you turn anything off, it 
seems much less likely to cause problems.

and if we can then get some of the big hardware vendors to create such 
files to enable all the drivers needed for their hardware.... (the big 
things are easy, it's when you get into the internal monitoring busses and 
so on that things get messy)

David Lang
