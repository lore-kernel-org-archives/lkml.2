Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0CVLX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:23:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0CVLXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:23:54 -0400
Date: Mon, 22 Mar 2010 12:23:40 +0100
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
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322112340.GD3483@elte.hu>
References: <20100318172805.GB26067@elte.hu>
 <4BA32E1A.2060703@redhat.com>
 <20100319085346.GG12576@elte.hu>
 <4BA3747F.60401@codemonkey.ws>
 <20100321191742.GD25922@elte.hu>
 <4BA67B2F.4030101@redhat.com>
 <20100321203121.GA30194@elte.hu>
 <4BA6900B.1040408@redhat.com>
 <20100321215207.GA13219@elte.hu>
 <4BA712F0.5030806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA712F0.5030806@redhat.com>
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

> IMO the reason perf is more usable than oprofile has less to do with the 
> kernel/userspace boundary and more do to with effort and attention spent on 
> the userspace/user boundary.
>
> [...]

If you are interested in the first-hand experience of the people who are doing 
the perf work then here it is: by far the biggest reason for perf success and 
perf usability is the integration of the user-space tooling with the 
kernel-space bits, into a single repository and project.

The very move you are opposing so vehemently for KVM.

Oprofile went the way you proposed, and it was a failure. It failed not 
because it was bad technology (it was pretty decent and people used it), it 
was not a failure because the wrong people worked on it (to the contrary, very 
capable people worked on it), it was a failure in hindsight because it simply 
incorrectly split into two projects which stiffled the progress of each other.

Obviously 3 years ago you'd have seen a similar, big "Oprofile is NOT broken!" 
flamewar, had i posted the same observations about Oprofile that i expressed 
about KVM here. (In fact there was a similar, big flamewar about all this when 
perf was posted a year ago.)

And yes, (as you are aware of) i see very similar patterns of inefficiency in 
the KVM/Qemu tooling relationship as well, hence did i express my views about 
it.

Thanks,

	Ingo
