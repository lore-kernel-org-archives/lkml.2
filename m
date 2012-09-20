Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2ITI7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:59:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46516 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2ITI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:59:04 -0400
Date: Thu, 20 Sep 2012 10:58:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] microcode fix for 3.6-rc7
Message-ID: <20120920085859.GA3611@gmail.com>
References: <20120919171610.GM4577@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919171610.GM4577@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi guys,
> 
> please pull this fix from Dan Carpenter which goes ontop of
> tip/x86/microcode. It would be best if it goes in during the upcoming
> merge window along with the rest from tip/x86/microcode so that we don't
> have any breakages.
> 
> Thanks.
> 
> The following changes since commit 2efb05e8e9fa3510044e007b90263c73b6a83f84:
> 
>   x86, microcode, AMD: Rewrite patch application procedure (2012-08-22 16:16:29 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/microcode_fix_3.7
> 
> for you to fetch changes up to 2d297480037e1d9100ca504737820c1bf65db6c0:
> 
>   x86, microcode, AMD: Fix use after free in free_cache() (2012-09-19 18:06:25 +0200)
> 
> ----------------------------------------------------------------
> A small list usage correction from Dan Carpenter.
> 
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       x86, microcode, AMD: Fix use after free in free_cache()
> 
>  arch/x86/kernel/microcode_amd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks Boris!

	Ingo
