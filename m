Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab1KUJC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:02:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:9914 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab1KUJCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:02:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78280088"
Subject: Re: [PATCH 2/3] kvm: use this_cpu_xxx replace percpu_xxx funcs
From: "Alex,Shi" <alex.shi@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@gentwo.org>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jeremy@xensource.com" <jeremy@xensource.com>
In-Reply-To: <4EA54694.5070703@redhat.com>
References: <1318237851.27949.190.camel@debian>
	 <alpine.DEB.2.00.1110101026080.16264@router.home>
	 <1318324774.27949.693.camel@debian>
	 <alpine.DEB.2.00.1110110910480.3388@router.home>
	 <1318382964.27949.782.camel@debian> <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>  <4E9E97D2.1040807@redhat.com>
	 <1319096041.23426.182.camel@debian> <1319424608.5061.25.camel@debian>
	 <4EA54694.5070703@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 17:02:08 +0800
Message-ID: <1321866128.30341.567.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-24 at 19:05 +0800, Avi Kivity wrote:
> On 10/24/2011 04:50 AM, Alex,Shi wrote:
> > On Thu, 2011-10-20 at 15:34 +0800, Alex,Shi wrote:
> > > percpu_xxx funcs are duplicated with this_cpu_xxx funcs, so replace them
> > > for further code clean up.
> > > 
> > > And in preempt safe scenario, __this_cpu_xxx funcs has a bit better
> > > performance since __this_cpu_xxx has no redundant preempt_disable()
> > > 
> >
> > Avi: 
> > Would you like to give some comments of this? 
> >
> 
> Sorry, was travelling:
> 
> Acked-by: Avi Kivity <avi@redhat.com>
> 

And this one, picking up or comments are all appreciated. :) 

