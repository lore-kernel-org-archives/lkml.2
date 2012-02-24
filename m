Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab2BXP1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:27:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47759 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2BXP1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:27:42 -0500
Date: Fri, 24 Feb 2012 16:27:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] x86/mce recovery cleanup patch
Message-ID: <20120224152717.GA25588@elte.hu>
References: <4f46976434651797d@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f46976434651797d@agluck-desktop.sc.intel.com>
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


* Luck, Tony <tony.luck@intel.com> wrote:

> Ingo,
> 
> This is the patch to replace some hard coded constants that we discussed
> here: https://lkml.org/lkml/2012/1/27/127
> 
> I'd coded it up four weeks ago, but forgot to send you a pull. This
> goes on top of the previous patchset for mce recovery that is sitting
> in your x86/mce branch of the tip tree waiting for the 3.4 merge window.
> 
> -Tony
> 
> The following changes since commit 5f7b88d51e89771f64c15903b96b5933dd0bc6d8:
> 
>   x86/mce: Recognise machine check bank signature for data path error (2012-01-03 12:07:07 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery-for-tip
> 
> for you to fetch changes up to 08dda402d60a721ac94e79efd7646b332be3e3b2:
> 
>   x86/mce: Replace hard coded hex constants with symbolic defines (2012-01-26 16:02:22 -0800)
> 
> ----------------------------------------------------------------
> Symbolic defines for architectural MCACOD constants
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       x86/mce: Replace hard coded hex constants with symbolic defines
> 
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)

Pulled, thanks Tony!

	Ingo
