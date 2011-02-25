Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1BYUU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:20:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139Ab1BYUUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:20:55 -0500
Message-ID: <4D680F07.1070709@zytor.com>
Date: Fri, 25 Feb 2011 12:20:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RESEND 1/1] Cleanup of asm-offsets.c(PAGE_SIZE_asm, PAGE_SHIFT_asm,
 THREAD_SIZE_asm)
References: <1298472122-4967-1-git-send-email-psomas@cslab.ece.ntua.gr> <1298664220-21548-1-git-send-email-psomas@cslab.ece.ntua.gr> <1298664220-21548-2-git-send-email-psomas@cslab.ece.ntua.gr>
In-Reply-To: <1298664220-21548-2-git-send-email-psomas@cslab.ece.ntua.gr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 12:03 PM, Stratos Psomadakis wrote:
> Cleanup of asm-offsets.c.
> 
> PAGE_SIZE_asm, PAGE_SHIFT_asm, THREAD_SIZE_asm can be safely removed from 
> asm-offsets.c, and be replaced by their non-'_asm' counterparts in the code 
> that uses them, since the _AC macro defined in include/linux/const.h makes
> PAGE_SIZE/PAGE_SHIFT/THREAD_SIZE work with as.
> 
> Signed-off-by: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
> ---
>  arch/mn10300/kernel/asm-offsets.c      |    2 --
>  arch/mn10300/kernel/gdb-io-ttysm-low.S |    2 +-
>  arch/x86/kernel/asm-offsets_32.c       |    4 ----
>  arch/x86/kernel/asm-offsets_64.c       |    1 -
>  arch/x86/kernel/entry_32.S             |    2 +-
>  arch/x86/kernel/head_32.S              |    8 ++++----
>  arch/x86/xen/xen-head.S                |    4 ++--
>  7 files changed, 8 insertions(+), 15 deletions(-)
> 

Looks good, but please separate the mn10300 and x86 chunks into separate
patches.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

