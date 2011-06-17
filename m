Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab1FQMIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 08:08:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39099 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838Ab1FQMIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 08:08:50 -0400
Date: Fri, 17 Jun 2011 14:08:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [GIT PULL] x86, microcode, AMD: 2 small fixlets
Message-ID: <20110617120834.GA25435@elte.hu>
References: <1308238327-27965-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308238327-27965-1-git-send-email-bp@amd64.org>
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


* Borislav Petkov <bp@amd64.org> wrote:

> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Hi Ingo,
> 
> please pull the following fixes from the below branch.
> 
> They are only minor correctness fixes and can be queued for 3.1.
> 
> Thanks.
> 
> The following changes since commit 2c53b436a30867eb6b47dd7bab23ba638d1fb0d2:
> 
>   Linux 3.0-rc3 (2011-06-13 15:29:59 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git ucode-fixes
> 
> Borislav Petkov (2):
>       x86, microcode, AMD: Correct buf references
>       x86, microcode, AMD: Fix section header size check
> 
>  arch/x86/kernel/microcode_amd.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)

Pulled, thanks Boris!

	Ingo
