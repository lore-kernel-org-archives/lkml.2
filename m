Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2CNGrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:47:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab2CNGrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:47:18 -0400
Date: Wed, 14 Mar 2012 07:47:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL] x86/mce two miscellaneous MCE fixes
Message-ID: <20120314064702.GA27480@elte.hu>
References: <4f5fbedd16019e0539@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f5fbedd16019e0539@agluck-desktop.sc.intel.com>
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

> The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:
> 
>   Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-for-tip
> 
> for you to fetch changes up to fadd85f16a8ec3fee8af599e79a209682dc52348:
> 
>   x86/mce: Fix return value of mce_chrdev_read() when erst is disabled (2012-02-22 13:14:16 -0800)
> 
> ----------------------------------------------------------------
> Two miscellaneous MCE fixes
> 
> ----------------------------------------------------------------
> Greg Kroah-Hartman (1):
>       x86/mce: Convert static array of pointers to per-cpu variables
> 
> Naoya Horiguchi (1):
>       x86/mce: Fix return value of mce_chrdev_read() when erst is disabled
> 
>  arch/x86/include/asm/mce.h           |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce.c     |   14 ++++++++++----
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++++----
>  3 files changed, 16 insertions(+), 9 deletions(-)

Pulled into tip:x86/mce, thanks Tony!

Thanks,

	Ingo
