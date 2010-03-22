Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0CVMWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:22:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVMWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:22:37 -0400
Date: Mon, 22 Mar 2010 13:22:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: oerg Roedel <joro@8bytes.org>
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
Message-ID: <20100322122228.GH3483@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322111040.GL13108@8bytes.org>
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


* oerg Roedel <joro@8bytes.org> wrote:

> On Sun, Mar 21, 2010 at 09:31:21PM +0100, Ingo Molnar wrote:
> > Lets see one example of that thought process in action: Oprofile.
> 
> Since you are talking so much about oProfile in this thread I think it is 
> important to mention that the problem with oProfile was not the repository 
> separation.
> 
> The problem was (and is) that the kernel and the user-space parts are 
> maintained by different people [...]

Caused by: repository separation and the inevitable code and social fork a 
decade later.

> [...] who dont talk to each other or have a direction where they want to go 
> with the project. [...]

Caused by: repository separation and the inevitable code and social fork a 
decade later.

> [...] Basically the reason of the oProfile failure is a disfunctional 
> community. [...]

Caused by: repository separation and the inevitable code and social fork a 
decade later.

> [...] I told the kernel-maintainer several times to also maintain 
> user-space but he didn't want that.
> 
> The situation with KVM is entirely different. Avi commits to kvm.git and 
> qemu-kvm.git so he maintains both. [...]

What you fail to realise (or what you fail to know, you werent around when 
Oprofile was written, i was) is that Oprofile _did_ have a functional single 
community when it was written. The tooling and the kernel bits was written by 
the same people.

But a decade is a long time and the drift happened due to the inevitability of 
the repository separation, and due to the _inability_ to reach a sane, usable 
solution within that framework of separation.

So i dont see much of a difference to the Oprofile situation really and i see 
many parallels. I also see similar kinds of desktop usability problems.

The difference is that we dont have KVM with a decade of history and we dont 
have a 'told you so' KVM reimplementation to show that proves the point. I 
guess it's a matter of time before that happens, because Qemu usability is so 
absymal today - so i guess we should suspend any discussions until that 
happens, no need to waste time on arguing hypoteticals.

I think you are rationalizing the status quo.

It's as if you argued in 1990 that the unification of East and West Germany 
wouldnt make much sense because despite clear problems and incompatibilites 
and different styles westerners were still allowed to visit eastern relatives 
and they both spoke the same language after all ;-)

Thanks,

	Ingo
