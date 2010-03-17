Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0CQIOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:14:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0CQIOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:14:31 -0400
Date: Wed, 17 Mar 2010 09:14:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Anthony Liguori <aliguori@linux.vnet.ibm.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100317081410.GD16374@elte.hu>
References: <4B9F84C0.70706@redhat.com>
 <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu>
 <4B9FC8B2.6070404@linux.vnet.ibm.com>
 <20100316182809.GA26602@elte.hu>
 <4BA00E6A.7080903@linux.vnet.ibm.com>
 <20100317004136.GC17472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100317004136.GC17472@redhat.com>
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
> On Tue, Mar 16, 2010 at 06:04:10PM -0500, Anthony Liguori wrote:
> > [...]
> > The only way to really address this is to change the interaction.  
> > Instead of running perf externally to qemu, we should support a perf 
> > command in the qemu monitor that can then tie directly to the perf 
> > tooling.  That gives us the best possible user experience.
> 
> To what extent could this be solved with less crossing of 
> isolation/abstraction layers, if the perfctr facilities were properly 
> virtualized? [...]

Note, 'perfctr' is a different out-of-tree Linux kernel project run by someone 
else: it offers the /dev/perfctr special-purpose device that allows raw, 
unabstracted, low-level access to the PMU.

I suspect the one you wanted to mention here is called 'perf' or 'perf 
events'. (and used to be called 'performance counters' or 'perfcounters' until 
it got renamed about a year ago)

Thanks,

	Ingo
