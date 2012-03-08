Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2CHKZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 05:25:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57673 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2CHKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 05:25:17 -0500
Date: Thu, 8 Mar 2012 11:24:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] mce: Fix RCU warning
Message-ID: <20120308102450.GA28434@elte.hu>
References: <20120307114138.GA21202@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307114138.GA21202@aftab>
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
> the following fixes an RCU splat which at least Srivatsa and I can
> trigger. It would be lovely if it went in into tip:urgent and to Linus
> before 3.3 is out.
> 
> Oh, and I ventured a try with signed tags, it looks good from here but
> let me know if I've missed anything.
> 
> Thanks a lot.
> 
> The following changes since commit 192cfd58774b4d17b2fe8bdc77d89c2ef4e0591d:
> 
>   Linux 3.3-rc6 (2012-03-03 17:08:09 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/mce-fix-for-3.3-rc6
> 
> for you to fetch changes up to b11e3d782b9c065b3b2fb543bfb0d97801822dc0:
> 
>   x86, mce: Fix rcu splat in drain_mce_log_buffer() (2012-03-07 11:44:29 +0100)
> 
> ----------------------------------------------------------------
> Fix a RCU warning in MCE code
> 
> ----------------------------------------------------------------
> Srivatsa S. Bhat (1):
>       x86, mce: Fix rcu splat in drain_mce_log_buffer()
> 
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulled, thanks!

	Ingo
