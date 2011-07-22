Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1GVBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 21:41:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:41932 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1GVBlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 21:41:03 -0400
Subject: Re: [RFC/PATCH] mm/futex: Fix futex writes on archs with SW
 tracking of dirty & young
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shan Hai <haishan.bai@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110721155938.2ff2dab5.akpm@linux-foundation.org>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins> <4E21A526.8010904@gmail.com>
	 <1310860194.25044.17.camel@pasglop>
	 <4b337921-d430-4b63-bc36-ad31753cf800@email.android.com>
	 <1310912990.25044.203.camel@pasglop> <1310944453.25044.262.camel@pasglop>
	 <1310961691.25044.274.camel@pasglop> <4E23D728.7090406@gmail.com>
	 <1310972462.25044.292.camel@pasglop> <4E23E02C.8090401@gmail.com>
	 <1310974591.25044.298.camel@pasglop> <4E24FA51.70602@gmail.com>
	 <1311049762.25044.392.camel@pasglop>
	 <20110721153606.37e6f432.akpm@linux-foundation.org>
	 <1311288726.25044.545.camel@pasglop>
	 <20110721155938.2ff2dab5.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:40:15 +1000
Message-ID: <1311298815.25044.562.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You're not understanding me.
> 
> I need a good reason to merge this into 3.0.
> 
> The -stable maintainers need even better reasons to merge this into
> earlier kernels.
> 
> Please provide those reasons!
> 
> (Documentation/stable_kernel_rules.txt, 4th bullet)
> 
> (And it's not just me and -stable maintainers.  Distro maintainers will
> also look at this patch and wonder whether they should merge it)

Well, as an arch maintainer, I can get stable maintainers to merge
anything I CC to stable :-)

Now, the good reason should have been rather obvious... it's a user
exploitable kernel lockup.

Cheers,
Ben.


