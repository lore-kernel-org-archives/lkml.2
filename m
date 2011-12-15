Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1LOHPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:15:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50447 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1LOHPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:15:01 -0500
Date: Thu, 15 Dec 2011 08:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86, microcode, AMD: Fixes for next merge window
Message-ID: <20111215071307.GE14237@elte.hu>
References: <20111214145846.GD23589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214145846.GD23589@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> Hi Ingo,
> 
> as promised, please pull from the branch below to receive the following
> fixes, they could be queued for the next merge window and simmer a while
> in linux-next until then.
> 
> Thanks.
> 
> The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:
> 
>   Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-verify-size
> 
> Borislav Petkov (5):
>       x86, microcode, AMD: Add a vendor-specific exit function
>       x86, microcode, AMD: Add a reusable buffer
>       x86, microcode, AMD: Simplify ucode verification
>       x86, microcode, AMD: Exit early on success
>       x86, microcode, AMD: Update copyrights
> 
>  arch/x86/include/asm/microcode.h |    2 +
>  arch/x86/kernel/microcode_amd.c  |  209 +++++++++++++++++++++-----------------
>  arch/x86/kernel/microcode_core.c |    5 +
>  3 files changed, 121 insertions(+), 95 deletions(-)

Pulled, thanks a lot Boris!

	Ingo
