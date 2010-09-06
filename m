Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0IFScf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:32:35 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60579 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0IFSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:32:30 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 02/14] arch/h8300: Removing dead ifdef __H8300_TLB_H__
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
	<c085d587a5fe2ae05ab431c746b96a0abb9fa876.1283782700.git.qy03fugy@stud.informatik.uni-erlangen.de>
X-Yow: I always have fun because I'm out of my mind!!!
Date: Mon, 06 Sep 2010 20:32:27 +0200
In-Reply-To: <c085d587a5fe2ae05ab431c746b96a0abb9fa876.1283782700.git.qy03fugy@stud.informatik.uni-erlangen.de>
	(Christian Dietrich's message of "Mon, 6 Sep 2010 16:36:00 +0200")
Message-ID: <m262yiwwn8.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de> writes:

> The nested __H8300_TLB_H__ include guard isn't necessary at this point,
> because the symbol is always defined at this point and the block
> content will always be removed.
>
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  arch/h8300/include/asm/tlb.h |   13 -------------
>  1 files changed, 0 insertions(+), 13 deletions(-)
>
> diff --git a/arch/h8300/include/asm/tlb.h b/arch/h8300/include/asm/tlb.h
> index 3dea80a..6339a02 100644
> --- a/arch/h8300/include/asm/tlb.h
> +++ b/arch/h8300/include/asm/tlb.h
> @@ -7,17 +7,4 @@
>  
>  #define tlb_flush(tlb)	do { } while(0)
>  
> -/* 
> -  include/asm-h8300/tlb.h 
> -*/
> -
> -#ifndef __H8300_TLB_H__
> -#define __H8300_TLB_H__
> -
> -#define tlb_flush(tlb)	do { } while(0)
> -
> -#include <asm-generic/tlb.h>
> -
> -#endif
> -
>  #endif

Looks like someone patched the file twice with the same patch, see
<http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=398f579808cb74dd4c418df72ff8ff5971038e4f#patch24>

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
