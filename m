Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab2EPNkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:40:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:9963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab2EPNkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:40:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100755388"
Message-ID: <4FB3AE32.8060006@intel.com>
Date: Wed, 16 May 2012 21:40:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the percpu tree with the tip tree
References: <20120516173616.ed5b60cf4b16e34a57206559@canb.auug.org.au>
In-Reply-To: <20120516173616.ed5b60cf4b16e34a57206559@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 03:36 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Today's linux-next merge of the percpu tree got a conflict in
> arch/x86/mm/tlb.c between commit a6fca40f1d7f ("x86, tlb: Switch cr3 in
> leave_mm() only when needed") from the tip tree and commit c6ae41e7d469
> ("x86: replace percpu_xxx funcs with this_cpu_xxx") from the percpu tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.


Thanks a lot!

My auto-scripts just watching upstream kernel, so missing this...

but happy to know the pain of code clean up is closing soon. ;)
