Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab0FIK2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:28:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37282 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476Ab0FIK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:27:58 -0400
Date: Wed, 9 Jun 2010 12:27:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [RFC] para virt interface of perf to support kvm guest os
 statistics collection in guest os
Message-ID: <20100609102743.GC1150@elte.hu>
References: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
 <4C0F51DD.3080200@redhat.com>
 <1276075280.2096.427.camel@ymzhang.sh.intel.com>
 <4C0F61D3.9000402@redhat.com>
 <1276078122.2046.1227.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276078122.2046.1227.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2010-06-09 at 12:41 +0300, Avi Kivity wrote:
> > 
> > >> Disabling the watchdog is unfortunate.  Why is it necessary?
> > >>      
> > > perf always uses NMI, so we disable the nmi_watchdog when a perf_event is
> > > set up in case they might have impact.
> > >    
> > 
> > Ok.  Is that the case for the hardware pmus as well?  If so it might be 
> > done in common code. 
> 
> The x86 hardware pmu implementation disables the lapic watchdog too, but 
> recent kernels come with a watchdog implementation on top of perf, the old 
> lapic one will be depricated.

Note, that code is in -tip, queued for v2.6.36.

	Ingo
