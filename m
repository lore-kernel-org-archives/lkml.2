Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0EJLOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 07:14:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0EJLOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 07:14:20 -0400
Date: Mon, 10 May 2010 13:14:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile hotplug fixes for x86
Message-ID: <20100510111411.GA25913@elte.hu>
References: <1273152374-9392-1-git-send-email-robert.richter@amd.com>
 <20100510103330.GE6450@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510103330.GE6450@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> On 06.05.10 15:26:07, Robert Richter wrote:
> > Ingo, I will send a separate pull request.
> 
> Ingo,
> 
> please pull oprofile hotplug fixes for x86 from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Thanks,
> 
> -Robert
> 
> --
> 
> The following changes since commit 5bdb7934ca4115a12c7d585c5a45312b1c36909b:
>   Robert Richter (1):
>         oprofile/x86: remove duplicate IBS capability check
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Robert Richter (7):
>       oprofile/x86: fix uninitialized counter usage during cpu hotplug
>       oprofile/x86: remove CONFIG_SMP macros
>       oprofile/x86: protect cpu hotplug sections
>       oprofile/x86: stop disabled counters in nmi handler
>       oprofile/x86: reordering some functions
>       oprofile/x86: notify cpus only when daemon is running
>       oprofile/x86: make AMD IBS hotplug capable
> 
>  arch/x86/oprofile/nmi_int.c      |  187 +++++++++++++++++++++++---------------
>  arch/x86/oprofile/op_model_amd.c |   54 +++--------
>  arch/x86/oprofile/op_x86_model.h |    2 +-
>  3 files changed, 130 insertions(+), 113 deletions(-)

Pulled, thanks Robert!

	Ingo
