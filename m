Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab0CVM3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:29:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0CVM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:29:36 -0400
Message-ID: <4BA7629B.7020604@redhat.com>
Date: Mon, 22 Mar 2010 14:29:15 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA47AD0.2010509@redhat.com> <20100321190656.GC25922@elte.hu> <4BA68009.5010906@redhat.com> <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu>
In-Reply-To: <20100322111411.GC3483@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 01:14 PM, Ingo Molnar wrote:
>
>> I think we agree at last.  Neither I nor my employer are interested in
>> running qemu as a desktop-on-desktop tool, therefore I don't invest any
>> effort in that direction, or require it from volunteers.
>>      
> Obviously your employer at least in part defers to you when it comes to KVM
> priorities.
>    

In part, yes.

> So, just to make this really clear, _you_ are not interested in running qemu
> as a desktop-on-desktop tool, subsequently this kind of
> disinterest-for-desktop-usability trickled through the whole KVM stack and
> poisoned your attitude and your contributor's attitude.
>    

I am also disinterested in ppc virtualization, yet it happened.  I am 
disinterested in ia64 virtualization, yet it happened.  I am 
disinterested in s390 virtualization, yet it happened.

Linus doesn't care about virtualization, yet it happened.

I don't tell my contributor what to be interested in, only whether their 
patches are good or not.  I can tell you that Red Hat contributors don't 
work on a desktop kvm GUI not because I discourage them, but because the 
product we are working on does not contain a desktop kvm GUI.  Jan 
Kiszka contributed a lot of debugger features, fixes, and improvement, 
presumably he and/or his employer need that more than a kvm desktop GUI.

I can't see why you see anything wrong with this.  People write patches 
for their own interest, not yours or mine.

> Too sad really and it's doubly sad that you dont feel anything wrong about
> that.
>    

It would be lovely to have a desktop kvm GUI.  I don't feel I have to 
write it myself or compel others to write it.  I don't feel sad about it.

>> If you think a good GUI is so badly needed, either write one yourself, or
>> convince someone else to do it.
>>      
> To a certain degree we are trying to do a small bit of that (see this very
> thread) - and you are NAK-ing and objecting the heck out of it via your
> unreasonable microkernelish and server-centric views.
>    

The perf bits have nothing to do with a GUI or usability for general 
users.  Calling them "unreasonable microkernelish sever-centric views" 
is just a way of not addressing them.

> With constant maintainer disinterest there's no wonder a non-desktop-oriented
> KVM becomes a self-fulfilling prophecy: you think the desktop does not matter,
> hence it becomes a reality in KVM space which you can constantly refer back to
> as a 'fact'.
>    

It's a fact that virtualization is happening in the data center, not on 
the desktop.  You think a kvm GUI can become a killer application? fine, 
write one.  You don't need any consent from me as kvm maintainer (if 
patches are needed to kvm that improve the desktop experience, I'll 
accept them, though they'll have to pass my unreasonable microkernelish 
filters).  If you're right then the desktop kvm GUI will be a huge hit 
with zillions of developers and people will drop Windows and switch to 
Linux just to use it.

But my opinion is that it will end up like virtualbox, a nice app that 
you can use to run Windows-on-Linux, but is not all that useful.

> Which i find dishonest and disingenious at best.
>    

If you're going to use words like 'dishonest' then please don't send me 
any more email.

>> (btw, why are you interested in desktop-on-desktop? one use case is
>> developers, which don't really need fancy GUIs; a second is people who test
>> out distributions, but that doesn't seem to be a huge population; and a
>> third is people running Windows for some application that doesn't run on
>> Linux - hopefully a small catergory as well.  Seems to be quite a small
>> target audience, compared to, say, video editing)
>>      
> I'm interested in desktop-on-desktop because i walk this world with open eyes
> and i care about Linux, and these days qemu-kvm is the first thing a new Linux
> user sees about Linux virtualization. I've observed several people i know in
> person to turn away from Linux and go back to Windows or go over to Apple
> because they had a much more mature solution.
>    

Which distribution are they using?  Most people would see virt-manager 
as the first thing, not open gnome-terminal and start typing in the qemu 
command line.  While it's not perfect, it does have a shiny GUI with 
lots of tabs and buttons.

> I'd probably turn away from Linux myself if i were a newbie and if i were
> forced to use KVM on the desktop today.
>
> Again, you dont seem to realize that you as a maintainer are at a central
> point where you have the ability to turn the self-fulfilling prophecy that
> 'nobody cares about the Linux desktop' into a reality - or where you have the
> ability to prevent it from happening. It is hugely harmful process, especially
> as you seem to delude yourself that you have nothing to do with it.
>    

It doesn't have to be me.  Better to pick someone who has a clue about 
usability to design and guide this effort.  That someone can work on 
qemu, or if they prefer, tools/kvm (we worked hard to avoid making kvm 
tied to a single userspace).

The kvm toolstack is maintained by multiple people - Marcelo and myself 
at the kernel level, Anthony and the other qemu maintainers at the qemu 
single-guest level, Daniel Veillard and Dan Berrange at the libvirt or 
host level, and Cole Robinson at the virt-manager or GUI level.  It's 
unreasonable to ask one person to do all of this, just like Linus 
doesn't maintain the scheduler even though it is so important.

> Anyway, it's good you expressed your views about this as this will help the
> chances of a fresh restart. (which chances are still not too good though)
>    

All that's needed is to find someone with the skills, time, and interest.

-- 
error compiling committee.c: too many arguments to function

