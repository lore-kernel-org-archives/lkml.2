Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab0KJIba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:31:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54623 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab0KJIb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:31:29 -0500
Date: Wed, 10 Nov 2010 09:31:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jesper Juhl <jj@chaosbits.net>, amd64-microcode@amd64.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] microcode, AMD: Cleanup code a bit
Message-ID: <20101110083121.GD3341@elte.hu>
References: <20101102175248.GA25781@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102175248.GA25781@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> get_ucode_data is a memcpy() wrapper which always returns 0. Move it
> into the header and make it an inline. Remove all code checking its
> return value and turn it into a void.
> 
> There should be no functionality change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/include/asm/microcode.h |    6 ++++++
>  arch/x86/kernel/microcode_amd.c  |   25 +++++--------------------
>  2 files changed, 11 insertions(+), 20 deletions(-)

Hm, what tree is this against - it doesnt apply here:

 Hunk #3 FAILED at 180.
 Hunk #4 succeeded at 195 (offset -1 lines).
 Hunk #5 succeeded at 211 (offset -1 lines).
 1 out of 5 hunks FAILED -- rejects in file arch/x86/kernel/microcode_amd.c

Thanks,

	Ingo
