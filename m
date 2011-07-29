Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab1G2LmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:42:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1G2Ll7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:41:59 -0400
X-Authority-Analysis: v=1.1 cv=YhhhcVvq/Bf3xBNEvzTEV9JHGW2mXul7kEbaqsyQnMQ= c=1 sm=0 a=_gBd66nM058A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=s8sO8zdt2mzRrH7oFxoA:9 a=hmwDVxcxYHUnJoGQrZwA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/5] x86: Do not differentiate between x86_64 and i386
 with init_per_cpu
From: Steven Rostedt <rostedt@goodmis.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAMzpN2jAKphUcp2eFfyVtn+ut+=oRqr40G3tTbDMziEg+TEuhw@mail.gmail.com>
References: <20110729014215.328710900@goodmis.org>
	 <20110729014247.692715109@goodmis.org>
	 <CAMzpN2jAKphUcp2eFfyVtn+ut+=oRqr40G3tTbDMziEg+TEuhw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 29 Jul 2011 07:41:56 -0400
Message-ID: <1311939716.21143.24.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 00:18 -0400, Brian Gerst wrote:
> Even though 32-bit doesn't currently use these macros, please keep the
> current define, since only 64-bit SMP is special in this regard.
> 64-bit SMP uses a zero-based percpu segment, which requires the linker
> fixup for statically initialized percpu pointers.  This fixup isn't
> needed on 32-bit SMP (or UP).

OK, fine, I'll remove this patch from the set and rebase.

Thanks,

-- Steve


