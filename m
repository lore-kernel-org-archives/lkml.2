Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0CVRji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:39:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984Ab0CVRjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:39:36 -0400
Date: Mon, 22 Mar 2010 18:39:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Frank Ch. Eigler" <fche@redhat.com>, Joerg Roedel <joro@8bytes.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
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
Message-ID: <20100322173923.GA25498@elte.hu>
References: <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <20100322111040.GL13108@8bytes.org>
 <20100322122228.GH3483@elte.hu>
 <20100322134633.GD1940@8bytes.org>
 <20100322163215.GC18796@elte.hu>
 <y0mmxy0wa1r.fsf@fche.csb>
 <84144f021003221027t1a3e7d6ft64612654c5e50da@mail.gmail.com>
 <4BA7A9AF.3010806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7A9AF.3010806@redhat.com>
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

> On 03/22/2010 07:27 PM, Pekka Enberg wrote:
> >
> > It's kinda funny to see people argue that having an external repository is 
> > not a problem and that it's not a big deal if building something from the 
> > repository is slightly painful as long as it doesn't require a PhD when we 
> > have _real world_ experience that it _does_ limit developer base in some 
> > cases. Whether or not that applies to kvm remains to be seen but I've yet 
> > to see a convincing argument why it doesn't.
> 
> qemu has non-Linux developers.  Not all of their contributions are relevant 
> to kvm but some are.  If we pull qemu into tools/kvm, we lose them.

Qemu had very few developers before KVM made use of it - i know it because i 
followed the project prior KVM.

So whatever development activitity Qemu has today, it's 99% [WAG] attributable 
to KVM. It might have non-Linux contributors, but they wouldnt be there if it 
wasnt for all the Linux contributors ...

Furthermore, those contributors wouldnt have to leave - they could simply use 
a different Git URI ...

	Ingo
