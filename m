Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1LBCe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:34:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:13397 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1LBCe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:34:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="43139889"
Subject: Re: [PATCH 1/3] net: use this_cpu_xxx replace percpu_xxx funcs
From: "Alex,Shi" <alex.shi@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <1321866051.30341.565.camel@debian>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319078687.23426.146.camel@debian>
	 <1319087281.8416.45.camel@edumazet-laptop>
	 <1319095929.23426.180.camel@debian>
	 <1319099893.3781.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1321866051.30341.565.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 10:33:20 +0800
Message-ID: <1322793200.11530.33.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-21 at 17:00 +0800, Alex,Shi wrote:
> On Thu, 2011-10-20 at 16:38 +0800, Eric Dumazet wrote:
> > Le jeudi 20 octobre 2011 à 15:32 +0800, Alex,Shi a écrit :
> > > percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
> > > for further code clean up.
> > > 
> > > And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
> > > performance since __this_cpu_xxx has no redundant preempt_disable()
> > > 
> > > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > > ---
> > >  net/netfilter/xt_TEE.c |   12 ++++++------
> > >  net/socket.c           |    4 ++--
> > >  2 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> > 
> > Thanks !
> 
> Anyone like to pick up this patch? or more comments for this? 

Kaber, David: 
I appreciate for your any comments on this. Could you like do me a
favor? 



