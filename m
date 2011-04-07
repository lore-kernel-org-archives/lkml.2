Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1DGH5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:57:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48466 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab1DGH5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:57:18 -0400
Date: Thu, 7 Apr 2011 09:57:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFT/PATCH v2 4/6] x86-64: vclock_gettime(CLOCK_MONOTONIC) can't
 ever see nsec < 0
Message-ID: <20110407075703.GD24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu>
 <e210b8eea527894eaf3aec8c30c8d2747e87a524.1302137785.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e210b8eea527894eaf3aec8c30c8d2747e87a524.1302137785.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@MIT.EDU> wrote:

> +
> +	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
> +	 * are all guaranteed to be nonnegative.
> +	 */

> +	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
> +	 * guaranteed to be between 0 and NSEC_PER_SEC.
> +	 */

Nor have you addressed stylistic review feedback i gave before ...

Really, we absolutely must insist on 110% attention to small details for 
patches that modify assembly code.

Thanks,

	Ingo
