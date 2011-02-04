Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab1BDRAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:00:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1BDRAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:00:11 -0500
Date: Fri, 4 Feb 2011 11:59:44 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, George Spelvin <linux@horizon.com>,
        Meelis Roos <mroos@linux.ee>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: P4 PMU -- Fix unflagged overflows test
Message-ID: <20110204165944.GB21209@redhat.com>
References: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5gCnhVos3Lu_0GZSxFQmvsNEYTO=Jq7UdmYb1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 03:17:28PM +0300, Cyrill Gorcunov wrote:
> Please apply it, sorry for non-inlined patch (have a web access only at moment).
> 
> Note that I've tested the patch on non-HT machine so if someone have HT'ed one
> -- it would be great to test the patch there.

Hmm. For some reason, when I enable the kgdb testsuite, the box fails to
boot with hardlockup issues.  It seems like the code is swallowing the
NMIs? I basically applied this patch on top of 2.6.38-rc3 and ran it on my
Xeon box (p4 w/HT).

Cheers,
Don
