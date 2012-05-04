Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2EDHzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:55:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57442 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2EDHzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:55:39 -0400
Date: Fri, 4 May 2012 09:55:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Tony Luck <tony.luck@intel.com>, x86 <x86@kernel.org>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] AMD MCE thresholding fixes for 3.5
Message-ID: <20120504075525.GA26539@gmail.com>
References: <20120430131232.GH9303@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120430131232.GH9303@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> Hi Ingo,
> 
> those are three patches which should fix the case where the APIC LVT
> thresholding interrupt is not supported. No hurry here, it can wait for
> the 3.5 merge window,
> 
> Thanks.
> 
> --
> The following changes since commit 69964ea4c7b68c9399f7977aa5b9aa6539a6a98a:
> 
>   Linux 3.4-rc5 (2012-04-29 15:19:10 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/amd-thresholding-fixes-for-3.5
> 
> for you to fetch changes up to 575203b4747c371698dd686b1fa6d0a3a0c47ac6:
> 
>   x86, MCE, AMD: Disable error thresholding bank 4 on some models (2012-04-30 13:22:54 +0200)
> 
> ----------------------------------------------------------------
> A three-patch set which makes the APIC LVT interrupt optional because a
> subset of F15h models don't support it.
> 
> ----------------------------------------------------------------
> Borislav Petkov (3):
>       x86, MCE, AMD: Make APIC LVT thresholding interrupt optional
>       x86, MCE, AMD: Hide interrupt_enable sysfs node
>       x86, MCE, AMD: Disable error thresholding bank 4 on some models
> 
>  arch/x86/kernel/cpu/mcheck/mce.c     |   37 +++++++++++++++++++
>  arch/x86/kernel/cpu/mcheck/mce_amd.c |   65 ++++++++++++++++++++++++++--------
>  2 files changed, 88 insertions(+), 14 deletions(-)

Pulled, thanks Boris!

	Ingo
