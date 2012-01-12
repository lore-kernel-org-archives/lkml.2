Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab2ALAph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:45:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41115 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab2ALApe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:45:34 -0500
Message-ID: <4F0E2D07.1010502@zytor.com>
Date: Wed, 11 Jan 2012 16:44:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "tj@kernel.org" <tj@kernel.org>
CC: "Alex,Shi" <alex.shi@intel.com>, Christoph Lameter <cl@gentwo.org>,
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
Subject: Re: [PATCH 3/3] Code clean up for percpu_xxx() functions
References: <1318428673.29699.13.camel@debian> <alpine.DEB.2.00.1110120910540.26610@router.home> <1318908091.23426.52.camel@debian> <alpine.DEB.2.00.1110180932330.687@router.home> <1319016218.23426.104.camel@debian> <alpine.DEB.2.00.1110191033480.24001@router.home> <1319096139.23426.184.camel@debian> <1321866612.30341.572.camel@debian> <20111122000653.GS25776@google.com> <1326272921.5695.263.camel@debian> <20120111171951.GF26832@google.com>
In-Reply-To: <20120111171951.GF26832@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 09:19 AM, tj@kernel.org wrote:
>
> Alex, can you please collect all patches into a single patchset?
> Please split it such that, usage changes are per-system so that they
> can be routed through respective subsystems (x86 or net) and updates
> to percpu proper which can be applied after other changes have been
> applied.  It would probably be best to route these patches separately
> rather than all through percpu as it touches a lot of different places
> and is likely to cause conflicts.  I *think* the best way would be,
>
> * Submit per-subsystem patches and get them merged to subsystem trees.
>
> * (Optional) Apply a patch to mark unused interface deprecated in
>    percpu tree, so that new usages in linux-next can be detected.
>
> * Towards the end of the next merge window, merge a patch to actually
>    kill the old interface.
>

That sounds like a good idea.

	-hpa
