Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0CUWBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:01:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab0CUWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:01:08 -0400
Date: Sun, 21 Mar 2010 23:00:52 +0100
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100321220052.GC13219@elte.hu>
References: <20100318170223.GB9756@elte.hu>
 <4BA25E66.2050800@redhat.com>
 <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA47AD0.2010509@redhat.com>
 <20100321190656.GC25922@elte.hu>
 <4BA68009.5010906@redhat.com>
 <20100321205531.GC30194@elte.hu>
 <4BA692C3.7010408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA692C3.7010408@redhat.com>
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

> > Consider the _other_ examples that are a lot more clear:
> >
> >    ' If you expose paravirt spilocks via KVM please also make sure the KVM
> >      tooling can make use of it, has an option for it to configure it, and
> >      that it has sufficient efficiency statistics displayed in the tool for
> >      admins to monitor.'
> >
> >    ' If you create this new paravirt driver then please also make sure it can
> >      be configured in the tooling. '
> >
> >    ' Please also add a testcase for this bug to tools/kvm/testcases/ so we dont
> >      repeat this same mistake in the future. '
> 
> All three happen quite commonly in qemu/kvm development.  Of course someone 
> who develops a feature also develops a patch that exposes it in qemu.  There 
> are several test cases in qemu-kvm.git/kvm/user/test.

If that is the theory then it has failed to trickle through in practice. As 
you know i have reported a long list of usability problems with hardly a look. 
That list could be created by pretty much anyone spending a few minutes of 
getting a first impression with qemu-kvm.

So something is seriously wrong in KVM land, to pretty much anyone trying it 
for the first time. I have explained how i see the root cause of that, while 
you seem to suggest that there's nothing wrong to begin with. I guess we'll 
have to agree to disagree on that.

Thanks,

	Ingo
