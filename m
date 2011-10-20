Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab1JTGK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 02:10:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:49971 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757Ab1JTGKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 02:10:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64994740"
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
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
In-Reply-To: <1319090667.23426.159.camel@debian>
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
	 <1319090667.23426.159.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 14:13:22 +0800
Message-ID: <1319091202.23426.163.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 14:04 +0800, Alex,Shi wrote:
> > Sorry this huge patch brings too many potential bugs.
> > 
> > I ask you a separate patch for the networking part, because I dont want
> > to Ack all the other parts.
> > 
> 
> Thanks a lot for review! I split the first patch into 2 according your
> suggestion. The second one for network here: 

Sorry for too big patch, any other split requirements? 

