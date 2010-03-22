Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0CVUfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:35:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59452 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CVUfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:35:32 -0400
Date: Mon, 22 Mar 2010 21:35:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100322203518.GC18126@elte.hu>
References: <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
 <20100322173400.GB15795@elte.hu>
 <4BA7B87A.8060104@codemonkey.ws>
 <20100322192259.GD21919@elte.hu>
 <4BA7C8C6.7080604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7C8C6.7080604@redhat.com>
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

> On 03/22/2010 09:22 PM, Ingo Molnar wrote:
> >
> >> Transitive had a product that was using a KVM context to run their binary 
> >> translator which allowed them full access to the host processes virtual 
> >> address space range.  In this case, there is no kernel and there are no 
> >> devices.
> >
> > And your point is that such vcpus should be excluded from profiling just 
> > because they fall outside the Qemu/libvirt umbrella?
> >
> > That is a ridiculous position.
> >
> 
> Non-guest vcpus will not be able to provide Linux-style symbols.

And why do you say that it makes no sense to profile them?

Also, why do you define 'guest vcpus' to be 'Qemu started guest vcpus'? If 
some other KVM using project (which you encouraged just a few mails ago) 
starts a vcpu we still want to be able to profile them.

	Ingo
