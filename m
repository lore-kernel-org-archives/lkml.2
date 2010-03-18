Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab0CRLA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:00:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34009 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0CRLAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:00:54 -0400
Date: Thu, 18 Mar 2010 11:58:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318105826.GA2174@elte.hu>
References: <20100316122903.GA8831@elte.hu>
 <4B9F7C6A.3070207@redhat.com>
 <20100316130840.GA24808@elte.hu>
 <4B9FBA8B.8020200@codemonkey.ws>
 <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E7E2.3010803@redhat.com>
 <20100318095418.GD2157@elte.hu>
 <4BA2030B.3090007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2030B.3090007@redhat.com>
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


* Jes Sorensen <Jes.Sorensen@redhat.com> wrote:

> On 03/18/10 10:54, Ingo Molnar wrote:
> >* Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
> [...]
> >>
> >>At my previous employer we ended up dropping all Xen efforts exactly because
> >>it was like maintaining two separate operating system kernels. The key to
> >>KVM is that once you have Linux, you practically have KVM as well.
> >
> >Yes. Please realize that what is behind it is a strikingly simple argument:
> >
> >  "Once you have a single project to develop and maintain all is much better."
> 
> Thats a very glorified statement but it's not reality, sorry. You can do 
> that with something like perf because it's so small and development of perf 
> is limited to a very small group of developers.

I was not talking about just perf: i am also talking about the arch/x86/ 
unification which is 200+ KLOC of highly non-trivial kernel code with hundreds 
of contributors and with 8000+ commits in the past two years.

Also, it applies to perf as well: people said exactly that a year ago: 'perf 
has it easy to be clean as it is small, once it gets as large as Oprofile 
tooling it will be in the same messy situation'.

Today perf has more features than Oprofile, has a larger and more complex code 
base, has more contributors, and no, it's not in the same messy situation at 
all.

So whatever you think of large, unified projects, you are quite clearly 
mistaken. I have done and maintained through two different types of 
unifications and the experience was very similar: both developers and users 
(and maintainers) are much better off.

	Ingo
