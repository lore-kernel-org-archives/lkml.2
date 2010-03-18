Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0CRN1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:27:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951Ab0CRN1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:27:02 -0400
Date: Thu, 18 Mar 2010 09:24:21 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
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
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
Message-ID: <20100318132421.GA23126@redhat.com>
References: <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318085607.GB2157@elte.hu> <F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de> <20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu> <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318130226.GB7424@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> > > [...]
> > > Distributions are very eager to update kernels even in stable periods of the 
> > > distro lifetime - they are much less willing to update user-space packages.
> > > [...]
> > 
> > Sorry, er, what?  What distributions eagerly upgrade kernels in stable 
> > periods, were it not primarily motivated by security fixes? [...]
> 
> Please check the popular distro called 'Fedora' for example

I do believe I've heard of it.  According to fedora bodhi, there have
been 18 kernel updates issues for fedora 11 since its release, of
which 12 were for purely security updates, and most of the other six
also contain security fixes.  None are described as 'enhancement'
updates.  Oh, what about fedora 12?  8 updates total, of which 5 are
security only, one for drm showstoppers, others including security
fixes, again 0 tagged as 'enhancement'.

So where is that "eagerness" again??  My sense is that most users are
happy to leave a stable kernel running as long as possible, and
distributions know this.  You surely must understand that the lkml
demographics are different.


> and its kernel upgrade policies.

[citation needed]


> > [...] What users eagerly replace their kernels?
>
> Those 99% who click on the 'install 193 updates' popup.

That's not "eager".  That's "I'm exasperated from guessing what's
really important; let's not have so many updates; meh".


- FChE
