Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2DNLcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:32:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37611 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab2DNLcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:32:41 -0400
Date: Sat, 14 Apr 2012 13:32:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] x86 microcode fix for 3.4
Message-ID: <20120414113235.GD24688@gmail.com>
References: <20120413101021.GC27686@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413101021.GC27686@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi Ingo,
> 
> please pull the following fix for 3.4 from Andreas. This is seen by
> people using 3.3 too thus the stable tagging.
> 
> Thanks.
> 
> ---
> The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:
> 
>   Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode-fix-for-3.4
> 
> for you to fetch changes up to 283c1f2558ef4a4411fe908364b15b73b6ab44cf:
> 
>   x86, microcode: Ensure that module is only loaded on supported AMD CPUs (2012-04-13 11:51:05 +0200)
> 
> ----------------------------------------------------------------
> A two-patch fix from Andreas taking care of a sysfs warning when the
> microcode driver is loaded on unsupported platforms.
> 
> ----------------------------------------------------------------
> Andreas Herrmann (2):
>       x86, microcode: Fix sysfs warning during module unload on unsupported CPUs
>       x86, microcode: Ensure that module is only loaded on supported AMD CPUs
> 
>  arch/x86/kernel/microcode_amd.c  |   12 +++++++-----
>  arch/x86/kernel/microcode_core.c |   10 ++++------
>  2 files changed, 11 insertions(+), 11 deletions(-)

Pulled, thanks!

	Ingo
