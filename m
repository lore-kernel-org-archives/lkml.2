Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0CVLOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:14:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0CVLOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:14:22 -0400
Date: Mon, 22 Mar 2010 12:14:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100322111411.GC3483@elte.hu>
References: <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
 <20100321190656.GC25922@elte.hu>
 <4BA68009.5010906@redhat.com>
 <20100321205531.GC30194@elte.hu>
 <4BA692C3.7010408@redhat.com>
 <20100321215455.GB13219@elte.hu>
 <4BA7187E.3050405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7187E.3050405@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/21/2010 11:54 PM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >>On 03/21/2010 10:55 PM, Ingo Molnar wrote:
> >>>Of course you could say the following:
> >>>
> >>>   ' Thanks, I'll mark this for v2.6.36 integration. Note that we are not
> >>>     able to add this to the v2.6.35 kernel queue anymore as the ongoing
> >>>     usability work already takes up all of the project's maintainer and
> >>>     testing bandwidth. If you want the feature to be merged sooner than that
> >>>     then please help us cut down on the TODO and BUGS list that can be found
> >>>     at XYZ. There's quite a few low hanging fruits there. '
> >>That would be shooting at my own foot as well as the contributor's since I
> >>badly want that RCU stuff, and while a GUI would be nice, that itch isn't on
> >>my back.
> >I think this sums up the root cause of all the problems i see with KVM pretty
> >well.
> 
> I think we agree at last.  Neither I nor my employer are interested in 
> running qemu as a desktop-on-desktop tool, therefore I don't invest any 
> effort in that direction, or require it from volunteers.

Obviously your employer at least in part defers to you when it comes to KVM 
priorities.

So, just to make this really clear, _you_ are not interested in running qemu 
as a desktop-on-desktop tool, subsequently this kind of 
disinterest-for-desktop-usability trickled through the whole KVM stack and 
poisoned your attitude and your contributor's attitude.

Too sad really and it's doubly sad that you dont feel anything wrong about 
that.

> If you think a good GUI is so badly needed, either write one yourself, or 
> convince someone else to do it.

To a certain degree we are trying to do a small bit of that (see this very 
thread) - and you are NAK-ing and objecting the heck out of it via your 
unreasonable microkernelish and server-centric views.

With constant maintainer disinterest there's no wonder a non-desktop-oriented 
KVM becomes a self-fulfilling prophecy: you think the desktop does not matter, 
hence it becomes a reality in KVM space which you can constantly refer back to 
as a 'fact'.

Which i find dishonest and disingenious at best.

> (btw, why are you interested in desktop-on-desktop? one use case is 
> developers, which don't really need fancy GUIs; a second is people who test 
> out distributions, but that doesn't seem to be a huge population; and a 
> third is people running Windows for some application that doesn't run on 
> Linux - hopefully a small catergory as well.  Seems to be quite a small 
> target audience, compared to, say, video editing)

I'm interested in desktop-on-desktop because i walk this world with open eyes 
and i care about Linux, and these days qemu-kvm is the first thing a new Linux 
user sees about Linux virtualization. I've observed several people i know in 
person to turn away from Linux and go back to Windows or go over to Apple 
because they had a much more mature solution.

I'd probably turn away from Linux myself if i were a newbie and if i were 
forced to use KVM on the desktop today.

Again, you dont seem to realize that you as a maintainer are at a central 
point where you have the ability to turn the self-fulfilling prophecy that 
'nobody cares about the Linux desktop' into a reality - or where you have the 
ability to prevent it from happening. It is hugely harmful process, especially 
as you seem to delude yourself that you have nothing to do with it.

Anyway, it's good you expressed your views about this as this will help the 
chances of a fresh restart. (which chances are still not too good though)

Thanks,
	
	Ingo
