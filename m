Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0CRNsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:48:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab0CRNsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:48:22 -0400
Date: Thu, 18 Mar 2010 14:48:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100318134813.GB25642@elte.hu>
References: <20100317081041.GC16374@elte.hu>
 <4BA1E24B.6090904@redhat.com>
 <20100318085607.GB2157@elte.hu>
 <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
 <20100318101025.GA13073@elte.hu>
 <4BA1FEB0.7000400@redhat.com>
 <20100318113527.GA13168@elte.hu>
 <y0m4okdzu4z.fsf@fche.csb>
 <20100318130226.GB7424@elte.hu>
 <20100318132421.GA23126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318132421.GA23126@redhat.com>
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -
> 
> > > > [...]
> > > > Distributions are very eager to update kernels even in stable periods of the 
> > > > distro lifetime - they are much less willing to update user-space packages.
> > > > [...]
> > > 
> > > Sorry, er, what?  What distributions eagerly upgrade kernels in stable 
> > > periods, were it not primarily motivated by security fixes? [...]
> > 
> > Please check the popular distro called 'Fedora' for example
> 
> I do believe I've heard of it.  According to fedora bodhi, there have
> been 18 kernel updates issues for fedora 11 since its release, of
> which 12 were for purely security updates, and most of the other six
> also contain security fixes.  None are described as 'enhancement'
> updates.  Oh, what about fedora 12?  8 updates total, of which 5 are
> security only, one for drm showstoppers, others including security
> fixes, again 0 tagged as 'enhancement'.
> 
> So where is that "eagerness" again??  My sense is that most users are
> happy to leave a stable kernel running as long as possible, and
> distributions know this.  You surely must understand that the lkml
> demographics are different.
> 
> > and its kernel upgrade policies.
> 
> [citation needed]

You are quite wrong, despite the sarcastic tone you are attempting to use, and 
this is distro kernel policy 101.

For distros such as Fedora it's simpler to support the same kernel version 
across many older versions of the distro than having to support different 
kernel versions.

Check Fedora 12 for example. Four months ago it was released with kernel 
v2.6.31:

 http://download.fedora.redhat.com/pub/fedora/linux/releases/12/Fedora/x86_64/os/Packages/kernel-2.6.31.5-127.fc12.x86_64.rpm

But if you update a Fedora 12 installation today you'll get kernel v2.6.32:

 http://download.fedora.redhat.com/pub/fedora/linux/updates/12/SRPMS/kernel-2.6.32.9-70.fc12.src.rpm

As a result you'll get a new 2.6.32 kernel on Fedora 12.

The end result is what i said in the previous mail: that you'll get a newer 
kernel even on a stable distro - while user-space packages will only be 
updated if there's a security issue (and even then there's no version jump 
like for the kernel).

> > > [...] What users eagerly replace their kernels?
> >
> > Those 99% who click on the 'install 193 updates' popup.
> 
> That's not "eager".  That's "I'm exasperated from guessing what's really 
> important; let's not have so many updates; meh".

Erm, fact is, 99% [WAG] of the users click on the update button and accept 
whatever kernel version the distro update offers them.

	Ingo
