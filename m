Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0DNKnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:43:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758Ab0DNKns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:43:48 -0400
Date: Wed, 14 Apr 2010 12:43:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH V3] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
Message-ID: <20100414104338.GA31348@elte.hu>
References: <1902387910.2078.435.camel@ymzhang.sh.intel.com>
 <4BC588CF.5010507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC588CF.5010507@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> On 04/14/2030 12:05 PM, Zhang, Yanmin wrote:
> >Here is the new patch of V3 against tip/master of April 13th
> >if anyone wants to try it.
> >
> 
> Thanks for persisting despite the flames.
> 
> Can you please separate arch/x86/kvm part of the patch?  That will make for 
> easier reviewing, and will need to go through separate trees.

Once it gets into a state that it can be applied could you please create a 
separate, -git based branch for it, so that i can pull it for testing and 
integration with the tools/perf/ bits?

Assuming there are no serious conflicts with pending KVM work.

(or i can do that too)

Thanks,

	Ingo
