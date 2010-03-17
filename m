Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0CQI7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:59:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45761 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab0CQI7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:59:13 -0400
Date: Wed, 17 Mar 2010 09:59:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100317085900.GG16374@elte.hu>
References: <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu>
 <4B9FC8B2.6070404@linux.vnet.ibm.com>
 <20100316182809.GA26602@elte.hu>
 <4BA00E6A.7080903@linux.vnet.ibm.com>
 <20100317004136.GC17472@redhat.com>
 <4BA05285.3070903@redhat.com>
 <20100317081641.GE16374@elte.hu>
 <4BA090CB.5020906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA090CB.5020906@redhat.com>
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

> On 03/17/2010 10:16 AM, Ingo Molnar wrote:
> >* Avi Kivity<avi@redhat.com>  wrote:
> >
> >> Monitoring guests from the host is useful for kvm developers, but less so
> >> for users.
> >
> > Guest space profiling is easy, and 'perf kvm' is not about that. (plain 
> > 'perf' will work if a proper paravirt channel is opened to the host)
> >
> > I think you might have misunderstood the purpose and role of the 'perf 
> > kvm' patch here? 'perf kvm' is aimed at KVM developers: it is them who 
> > improve KVM code, not guest kernel users.
> 
> Of course I understood it.  My point was that 'perf kvm' serves a tiny 
> minority of users. [...]

I hope you wont be disappointed to learn that 100% of Linux, all 13+ million 
lines of it, was and is being developed by a tiny, tiny, tiny minority of 
users ;-)

> [...]  That doesn't mean it isn't useful, just that it doesn't satisfy all 
> needs by itself.

Of course - and it doesnt bring world peace either. One step at a time.

Thanks,

	Ingo
