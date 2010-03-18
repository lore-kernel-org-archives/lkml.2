Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0CRQyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 12:54:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39653 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0CRQyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 12:54:49 -0400
Date: Thu, 18 Mar 2010 17:54:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100318165435.GA9756@elte.hu>
References: <20100316173940.GA23859@elte.hu>
 <4BA00F1F.1090907@codemonkey.ws>
 <20100317081041.GC16374@elte.hu>
 <4BA1E7E2.3010803@redhat.com>
 <20100318095418.GD2157@elte.hu>
 <4BA2030B.3090007@redhat.com>
 <20100318105826.GA2174@elte.hu>
 <4BA2296A.90401@redhat.com>
 <20100318142255.GG25642@elte.hu>
 <4BA23CA5.20801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA23CA5.20801@redhat.com>
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

> On 03/18/10 15:22, Ingo Molnar wrote:
> >
> >* Jes Sorensen<Jes.Sorensen@redhat.com>  wrote:
> >>Both perf and oprofile are still relatively small projects in comparison to
> >>QEMU.
> >
> >So is your argument that the unification does not make sense due to size?
> >Would a smaller Qemu be more appropriate for this purpose?
> 
> As I have stated repeatedly in this discussion, a unification would hurt the 
> QEMU development process because it would alienate a large number of QEMU 
> developers who are *not* Linux kernel users.

I took a quick look at the qemu.git log and more than half of all recent 
contributions came from Linux distributors.

So without KVM Qemu would be a much, much smaller project. It would be similar 
to how it was 5 years ago.

> QEMU is a lot more complex than you let on.

Please educate me then about the specifics.

> >>Well I think we are just going to agree to disagree on this one. I am not
> >>against merging projects where it makes sense, but in this particular case I
> >>am strongly convinced the loss would be much greater than the gain.
> >
> >I wish you said that based on first hand negative experience with
> >unifications, not based on just pure speculation.
> >
> >(and yes, i speculate too, but at least with some basis)
> 
> You still haven't given us a *single* example of unification of something 
> that wasn't purely linked to the Linux kernel. perf/ oprofile is 100% linked 
> to the Linux kernel, QEMU is not. I wish you would actually look at what 
> users use QEMU for. As long as you continue to purely speculate on this, to 
> use your own words, your arguments are not holding up.

The stats show that the huge increase in Qemu contributions over the past few 
years was mainly due to KVM. Do you claim it wasnt? What other projects make 
use of it and pay developers to work on it?

> And you are not being consistent either. You have conveniently continue to 
> ignore my questions about why the file system tools are not to be merged 
> into the Linux kernel source tree?

Sorry, i didnt comment on it because the answer is obvious: the file system 
tools and pretty much any Linux-exclusive tool (such as udev) should be moved 
there. The difference is that there's not much active development done in most 
of those tools so the benefits are probably marginal. Both Qemu and KVM is 
being developed very actively though, so development model inefficiencies show 
up.

Anyway, i didnt think i'd step into such a hornet's nest by explaining what i 
see as KVM's biggest weakness today and how i suggest it to be fixed :-)

If you dont agree with me, then dont do it - no need to get emotional about 
it.

Thanks,

	Ingo
