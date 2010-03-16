Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0CPQgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:36:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55824 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314Ab0CPQgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:36:00 -0400
Date: Tue, 16 Mar 2010 17:35:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100316163537.GA17537@elte.hu>
References: <20100316112500.GA5337@elte.hu>
 <4B9F77E7.2060101@redhat.com>
 <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <20100316160822.GE9841@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316160822.GE9841@redhat.com>
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
> On Tue, Mar 16, 2010 at 04:52:21PM +0100, Ingo Molnar wrote:
> > [...]
> > > Perhaps the fact that kvm happens to deal with an interesting application 
> > > area (virtualization) is misleading here.  As far as the host kernel or 
> > > other host userspace is concerned, qemu is just some random unprivileged 
> > > userspace program [...]
> 
> > You are quite mistaken: KVM isnt really a 'random unprivileged
> > application' in this context, it is clearly an extension of
> > system/kernel services.
> 
> I don't know what "extension of system/kernel services" means in this 
> context, beyond something running on the system/kernel, like every other 
> process. [...]

It means something like my example of 'extended to guest space' 
/proc/kallsyms:

> > [...]
> >
> > ( Which can be seen from the simple fact that what started the
> >   discussion was 'how do we get /proc/kallsyms from the guest'. I.e. an 
> >   extension of the existing host-space /proc/kallsyms was desired. )
> 
> (Sorry, that smacks of circular reasoning.)

To me it sounds like an example supporting my point. /proc/kallsyms is a 
service by the kernel, and 'perf kvm' desires this to be extended to guest 
space as well.

Thanks,

	Ingo
