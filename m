Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1JTHR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 03:17:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:63547 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1JTHRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:17:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,377,1315206000"; 
   d="scan'208";a="64451031"
Subject: [PATCH 0/3] code clean and optimzed for percpu_xxx serials funcs
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
In-Reply-To: <1319087281.8416.45.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 15:20:22 +0800
Message-ID: <1319095222.23426.175.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Think over Eric's requirement, I split my old patches and reorganized
them into 3 small patches, include net, kvm and a final clean up patch.
Since the clean up contents has no change beside move kvm/net part into
seprated patches. I keep Christoph's ack. Hope these are what you
want. :)

Regards
Alex

