Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0JRDG6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:06:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:36932 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab0JRDG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:06:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,344,1283756400"; 
   d="scan'208";a="617651545"
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
From: Huang Ying <ying.huang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <1287312163.1998.158.camel@laptop>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
	 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
	 <1287250157.1998.124.camel@laptop>  <20101017004641.GB4140@redhat.com>
	 <1287312163.1998.158.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Oct 2010 11:06:54 +0800
Message-ID: <1287371214.31526.23.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 18:42 +0800, Peter Zijlstra wrote:
> On Sat, 2010-10-16 at 20:46 -0400, Don Zickus wrote:
> 
> > Hmm, well to his defense, he isn't adding DIE_NMI_IPI.  That code is
> > already there.  He is just re-arranging it, making it look painfully
> > obvious the die_chain probably isn't as efficient as it should be.
> > 
> > I think a bunch of us agree that we need to revamp the NMI notifier to
> > make it less wasteful.  I was hoping we could do that in a separate patch
> > that would be layered on top of Huangs.
> > 
> > Would you object to at least consider having this patch series in a
> > work-in-progress git branch that we can build on top of, with the final
> > outcome containing an nmi notifier that meets your expectations?
> 
> What's the point of keeping it in a git tree? Its just a few patches.
> 
> We've spend more time talking about this than it would take to actually
> do the patch that kills DIE_NMI_IPI.

You can kill DIE_NMI_IPI. But you will add at least NMI_PRIORITY_LOCAL
(like DIE_NMI_IPI), NMI_PRIORITY_GLOBAL (like original DIE_NMI). So
thing is similar, just moved from one place to another place.

Best Regards,
Huang Ying


