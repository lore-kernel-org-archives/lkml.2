Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0CRRCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:02:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57953 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0CRRCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:02:38 -0400
Date: Thu, 18 Mar 2010 18:02:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
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
Message-ID: <20100318170223.GB9756@elte.hu>
References: <4BA20EB8.60707@redhat.com>
 <20100318114821.GB13168@elte.hu>
 <4BA21B09.6060706@redhat.com>
 <20100318130047.GA7424@elte.hu>
 <4BA23FE1.5050402@codemonkey.ws>
 <20100318151737.GA2875@elte.hu>
 <4BA250BF.80704@codemonkey.ws>
 <20100318162853.GB447@elte.hu>
 <4BA256FE.5080501@codemonkey.ws>
 <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021003180951s5207de16p1cdf4b9b04040222@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Thu, Mar 18, 2010 at 6:38 PM, Anthony Liguori <anthony@codemonkey.ws> wrote:
> >>>> There are all kernel space projects, going through Xorg would be a
> >>>> horrible waste of performance for full-screen virtualization. It's fine
> >>>> for the windowed or networked case (and good as a compatibility
> >>>> fallback), but very much not fine for local desktop use.
> >>
> >> For the full-screen case (which is a very common mode of using a guest OS
> >> on the desktop) there's not much of window management needed. You need to
> >> save/restore as you switch in/out.
> >
> > I don't think I've ever used full-screen mode with my VMs and I use
> > virtualization on a daily basis.
> >
> > We hear very infrequently from users using full screen mode.
> 
> Sorry for getting slightly off-topic but I find the above statement 
> interesting.
> 
> I don't use virtualization on daily basis but a working, fully integrated 
> full-screen model with VirtualBox was the only reason I bothered to give VMs 
> a second chance. From my point of view, the user experience of earlier 
> versions (e.g. Parallels) was just too painful to live with.

That's the same i do, and that's what i'm hearing from other desktop users as 
well.

The moment you work seriously in a guest OS you often want to switch to it 
full-screen, to maximize screen real-estate and to reduce host GUI element 
distractions. If it's just casual use of a single app then windowed mode 
suffices (but in that case performance doesnt matter much to begin with).

I find the 'KVM mostly cares about the server, not about the desktop' attitude 
expressed in this thread troubling.

> /me crawls back to his hole now...

/me should do that too - this discussion is not resulting in any positive 
result so it has become rather pointless.

	Ingo
