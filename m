Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1I1G7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:59:39 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:41663 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1I1G7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:59:37 -0400
Date: Wed, 28 Sep 2011 08:58:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Andre Przywara <andre.przywara@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] x86: perf_event_amd.c needs <asm/apicdef.h>
Message-ID: <20110928065801.GA14126@elte.hu>
References: <20110926172348.be01ff9a1c16267ffd000d2a@canb.auug.org.au>
 <4E820138.90301@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E820138.90301@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <rdunlap@xenotime.net> wrote:

> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error by adding <asm/apicdef.h> header file:
> 
> arch/x86/kernel/cpu/perf_event_amd.c:350:2: error: 'BAD_APICID' undeclared (first use in this function)
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
> 
> Found in linux-next and patch only applies cleanly to linux-next,
> but looks like mainline could use a similar patch (with more
> header files).
> 
>  arch/x86/kernel/cpu/perf_event_amd.c |    1 +
>  1 file changed, 1 insertion(+)

Applied to tip:perf/core, thanks Randy!

	Ingo
