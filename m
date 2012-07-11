Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2GKUxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 16:53:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49137 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab2GKUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 16:53:12 -0400
Date: Wed, 11 Jul 2012 22:53:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [GIT PULL v2] x86/mce fix (ready for 3.6 merge window)
Message-ID: <20120711205305.GA4652@gmail.com>
References: <CA+8MBbJjhVgEM7bJzZOSFvT6+RBLUQV6KtdzShuBxBH_nDxo4w@mail.gmail.com>
 <4ffdbbb9135702cfae@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ffdbbb9135702cfae@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:
> 
>   Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-ripvfix
> 
> for you to fetch changes up to 6751ed65dc6642af64f7b8a440a75563c8aab7ae:
> 
>   x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults (2012-07-11 10:20:47 -0700)
> 
> ----------------------------------------------------------------
> Fix application level machine check recovery
> 
> ----------------------------------------------------------------
> Tony Luck (1):
>       x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults
> 
>  arch/x86/kernel/cpu/mcheck/mce.c |  6 ++++--
>  include/linux/mm.h               |  1 +
>  mm/memory-failure.c              | 14 ++++++++------
>  3 files changed, 13 insertions(+), 8 deletions(-)

Pulled, thanks Tony!

	Ingo
