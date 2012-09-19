Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2ISQjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:39:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48246 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab2ISQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:39:42 -0400
Date: Wed, 19 Sep 2012 18:39:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] RAS changes for 3.7
Message-ID: <20120919163937.GB28297@gmail.com>
References: <20120917175955.GK13879@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917175955.GK13879@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi guys,
> 
> just a "enable MCE by default" patch and a trivial cleanup.
> 
> Please pull,
> Thanks.
> 
> The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:
> 
>   Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/ras_queue_for_3.7
> 
> for you to fetch changes up to 57639bedd2b8268daa791efcfd0367b9031b057d:
> 
>   x86, MCE: Remove unused defines (2012-09-17 19:33:38 +0200)
> 
> ----------------------------------------------------------------
> Patch 1/2 which enables MCA by default because I still see bugreports
> where CONFIG_X86_MCE is disabled and this is a bad idea so turning it on
> by default makes sense to me. The second one is a trivial cleanup.
> 
> ----------------------------------------------------------------
> Borislav Petkov (2):
>       x86, mce: Enable MCA support by default
>       x86, MCE: Remove unused defines
> 
>  arch/x86/Kconfig           |  1 +
>  arch/x86/include/asm/mce.h | 12 +-----------
>  2 files changed, 2 insertions(+), 11 deletions(-)

Pulled, thanks Boris!

	Ingo
