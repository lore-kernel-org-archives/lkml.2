Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0CVNqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:46:36 -0400
Received: from 8bytes.org ([88.198.83.132]:34722 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab0CVNqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:46:35 -0400
Date: Mon, 22 Mar 2010 14:46:33 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100322134633.GD1940@8bytes.org>
References: <4BA25E66.2050800@redhat.com> <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com> <20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws> <20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com> <20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org> <20100322122228.GH3483@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322122228.GH3483@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 01:22:28PM +0100, Ingo Molnar wrote:
> 
> * Joerg Roedel <joro@8bytes.org> wrote:
> 
> > [...] Basically the reason of the oProfile failure is a disfunctional 
> > community. [...]
> 
> Caused by: repository separation and the inevitable code and social fork a 
> decade later.

No, the split-repository situation was the smallest problem after all.
Its was a community thing. If the community doesn't work a single-repo
project will also fail. Look at the state of the alpha arch in Linux
today, it is maintained in one repository but nobody really cares about
it. Thus it is miles behine most other archs Linux supports today in
quality and feature completeness.

> What you fail to realise (or what you fail to know, you werent around when 
> Oprofile was written, i was) is that Oprofile _did_ have a functional single 
> community when it was written. The tooling and the kernel bits was written by 
> the same people.

Yes, this was probably the time when everybody was enthusiastic about
the feature and they could attract lots of developers. But situation
changed over time.

> So i dont see much of a difference to the Oprofile situation really and i see 
> many parallels. I also see similar kinds of desktop usability problems.

The difference is that KVM has a working community with good developers
and maintainers.

> The difference is that we dont have KVM with a decade of history and we dont 
> have a 'told you so' KVM reimplementation to show that proves the point. I 
> guess it's a matter of time before that happens, because Qemu usability is so 
> absymal today - so i guess we should suspend any discussions until that 
> happens, no need to waste time on arguing hypoteticals.

We actually have lguest which is small. But it lacks functionality and
the developer community KVM has attracted.

> I think you are rationalizing the status quo.

I see that there are issues with KVM today in some areas. You pointed
out the desktop usability already. I personally have trouble with the
qem-kvm.git because it is unbisectable. But repository unification
doesn't solve the problem here.
The point for a single repository is that it simplifies the development
process. I agree with you here. But the current process of KVM is not
too difficult after all. I don't have to touch qemu sources for most of
my work on KVM.

> It's as if you argued in 1990 that the unification of East and West Germany 
> wouldnt make much sense because despite clear problems and incompatibilites 
> and different styles westerners were still allowed to visit eastern relatives 
> and they both spoke the same language after all ;-)

Um, hmm. I don't think these situations have enough in common to compare
them ;-)

	Joerg



