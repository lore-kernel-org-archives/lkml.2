Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab2JAHX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 03:23:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64631 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2JAHX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 03:23:57 -0400
Date: Mon, 1 Oct 2012 09:23:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [GIT PULL] x86/mce allow bios to set per-bank CMCI threshold
Message-ID: <20121001072352.GA17166@gmail.com>
References: <506492bb2170819722@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506492bb2170819722@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> The following changes since commit 961ebea4ae68075bb5a0acc19f5852bed82bb877:
> 
>   Merge tag 'ras_queue_for_3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/mce (2012-09-19 17:01:50 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-naveen
> 
> for you to fetch changes up to 450cc201038f31bd496e1b3a44a49790b8827a06:
> 
>   x86/mce: Provide boot argument to honour bios-set CMCI threshold (2012-09-27 10:08:00 -0700)
> 
> ----------------------------------------------------------------
> Option to let the bios set per-bank CMCI thresholds so they can
> filter noisy error sources at a fine grained level based on platform
> specific knowledge.
> 
> ----------------------------------------------------------------
> Naveen N. Rao (1):
>       x86/mce: Provide boot argument to honour bios-set CMCI threshold
> 
>  Documentation/x86/x86_64/boot-options.txt |  7 +++++++
>  arch/x86/include/asm/mce.h                |  1 +
>  arch/x86/kernel/cpu/mcheck/mce.c          | 10 +++++++++
>  arch/x86/kernel/cpu/mcheck/mce_intel.c    | 35 ++++++++++++++++++++++++++++---
>  4 files changed, 50 insertions(+), 3 deletions(-)

Pulled, thanks!

	Ingo
