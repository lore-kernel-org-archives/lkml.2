Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab1LOSLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:11:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063Ab1LOSLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:11:48 -0500
Date: Thu, 15 Dec 2011 19:09:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, edac-devel <linux-edac@vger.kernel.org>,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86, MCE: Decode early errors too
Message-ID: <20111215180952.GC30567@elte.hu>
References: <20111214150252.GE23589@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111214150252.GE23589@aftab>
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
> please pull from the branch below to receive the functionality which
> enables decoding of MCEs which have happened early during boot, before
> MCA has been initiated.
> 
> Also for the next merge window.
> Thanks.
> 
> The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:
> 
>   Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git early-mce-decode
> 
> Borislav Petkov (2):
>       x86, mce: Add wrappers for registering on the decode chain
>       x86, MCE: Drain mcelog buffer
> 
>  arch/x86/include/asm/mce.h       |    3 +-
>  arch/x86/kernel/cpu/mcheck/mce.c |   64 +++++++++++++++++++++++++++++++++----
>  drivers/edac/i7core_edac.c       |    4 +-
>  drivers/edac/mce_amd.c           |    4 +-
>  drivers/edac/sb_edac.c           |    6 +--
>  5 files changed, 65 insertions(+), 16 deletions(-)

Pulled, thanks Boris!

	Ingo
