Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1CAH5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:57:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52735 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1CAH5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:57:42 -0500
Date: Tue, 1 Mar 2011 08:57:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATHC -tip 1/2] x86, nmi: Define a name for NMI control port
Message-ID: <20110301075712.GA13857@elte.hu>
References: <4D6C163A.4010904@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6C163A.4010904@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Also add a comment anout why we need in-out operations.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/include/asm/mach_traps.h |   18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/mach_traps.h
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/mach_traps.h
> +++ linux-2.6.git/arch/x86/include/asm/mach_traps.h
> @@ -8,6 +8,7 @@
>  #include <asm/mc146818rtc.h>
> 
>  #define NMI_REASON_PORT		0x61
> +#define NMI_ENABLE_PORT		0x70 /* Real-Time Clock Address Register as well */

FYI, the patch is whitespace damaged.

	Ingo
