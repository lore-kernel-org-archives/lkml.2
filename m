Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0CVO13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:27:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60982 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab0CVO11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:27:27 -0400
Date: Mon, 22 Mar 2010 15:26:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322142657.GD14201@elte.hu>
References: <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321200849.GA51323@dspnet.fr.eu.org>
 <4BA67D75.8060809@redhat.com>
 <20100321203704.GB30194@elte.hu>
 <4BA71012.7070004@redhat.com>
 <20100322113931.GE3483@elte.hu>
 <4BA76649.5080307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA76649.5080307@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 03/22/2010 01:39 PM, Ingo Molnar wrote:
> >
> > Reality is, the server space never was and never will be self-sustaining 
> > in the long run (as Novell has found it out with Netware), it is the 
> > desktop that dictates future markets. This is why i find your views about 
> > this naive and shortsighted.
> 
> Yet Linux is gaining ground in the server and embedded space while 
> struggling on the desktop. [...]

Frankly, Linux is mainly growing in the server space due to:

 1) the server space is technically much simpler than the desktop space. It
    is far easier to code up a server performance feature than to make
    struggle through stupid (server-motivated) package boundaries and get
    something done on the desktop. It is far easier to code up a server app
    as that space is well standardized and servers tend to be compartmented.
    Integration between server apps is much less common than integration
    between desktop apps, hence the harm that our modularization idiocies
    cause less harm.

 2) Linux's growth is still feeding on the remains of the destruction of Unix.

Linux is struggling on the desktop due to the desktop's inherent complexity, 
due to the lack of the Unix inertia and due to incompetence, insensitivity, 
intellectual arrogance and shortsightedness of server-centric thinking, like 
your arguments/position displayed in this very thread.

> [...] Apple is gaining ground on the desktop but is invisible on the server 
> side (despite having a nice product - Xserve).

But the thing is, Apple doesnt really care about the server space, yet. It is 
lucrative but it is a side-show: it will fall automatically to the 'winner' of 
the desktop (or gadget) of tomorrow.

Has the quick fall of Banyan Vines or Netware (both excellent all-around 
server products) taught you nothing?

We need a lot more desktop focus in the kernel community. The best method to 
achieve this, that i know of currently, is to simply have kernel developers 
think outside the kernel box and to have them do bits of user-space coding as 
well - and in particular desktop coding. To eat our own dogfood in essence. 
Suffer through crap we cause to user-space. To face the _real_ difficulties of 
users. We seem to have forgotten our roots.

> [...]
>
> It's true Windows achieved server dominance through it's desktop power, but 
> I don't think that's what keeping them there now.

What is keeping them there is precisely that.

> In any case, I'm not going to write a kvm GUI.  It doesn't match my skills, 
> interest, or my employer's interest.  If you wish to see a kvm GUI you have 
> to write one yourself or convince someone to write it (perhaps convince Red 
> Hat to fund such an effort beyond virt-manager).

As a maintainer you certainly dont have to write a single line of code, if you 
dont want to. You 'just' need to care about the big picture and encourage/help 
the flow and balance of the whole project.

	Ingo
