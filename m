Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2ALCGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:06:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:16888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab2ALCGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="55684950"
Subject: Re: [PATCH 3/3] Code clean up for percpu_xxx() functions
From: "Alex,Shi" <alex.shi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "tj@kernel.org" <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "avi@redhat.com" <avi@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <4F0E2D07.1010502@zytor.com>
References: <1318428673.29699.13.camel@debian>
	 <alpine.DEB.2.00.1110120910540.26610@router.home>
	 <1318908091.23426.52.camel@debian>
	 <alpine.DEB.2.00.1110180932330.687@router.home>
	 <1319016218.23426.104.camel@debian>
	 <alpine.DEB.2.00.1110191033480.24001@router.home>
	 <1319096139.23426.184.camel@debian> <1321866612.30341.572.camel@debian>
	 <20111122000653.GS25776@google.com> <1326272921.5695.263.camel@debian>
	 <20120111171951.GF26832@google.com>  <4F0E2D07.1010502@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 10:05:04 +0800
Message-ID: <1326333904.5695.311.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 16:44 -0800, H. Peter Anvin wrote:
> On 01/11/2012 09:19 AM, tj@kernel.org wrote:
> >
> > Alex, can you please collect all patches into a single patchset?
> > Please split it such that, usage changes are per-system so that they
> > can be routed through respective subsystems (x86 or net) and updates
> > to percpu proper which can be applied after other changes have been
> > applied.  It would probably be best to route these patches separately
> > rather than all through percpu as it touches a lot of different places
> > and is likely to cause conflicts.  I *think* the best way would be,
> >
> > * Submit per-subsystem patches and get them merged to subsystem trees.
> >
> > * (Optional) Apply a patch to mark unused interface deprecated in
> >    percpu tree, so that new usages in linux-next can be detected.
> >
> > * Towards the end of the next merge window, merge a patch to actually
> >    kill the old interface.
> >
> 
> That sounds like a good idea.

I will try to do so. Many thanks for the advices! 
> 
> 	-hpa


