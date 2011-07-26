Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1GZThA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:37:00 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39193 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1GZTg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:36:57 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Remove extra semicolon's in the kernel.
References: <1311704763-6682-1-git-send-email-justinmattock@gmail.com>
X-Yow: Give them RADAR-GUIDED SKEE-BALL LANES and VELVEETA BURRITOS!!
Date: Tue, 26 Jul 2011 21:36:54 +0200
In-Reply-To: <1311704763-6682-1-git-send-email-justinmattock@gmail.com>
	(Justin P. Mattock's message of "Tue, 26 Jul 2011 11:26:03 -0700")
Message-ID: <m2zkk0q1ex.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Justin P. Mattock" <justinmattock@gmail.com> writes:

> diff --git a/arch/ia64/include/asm/mca_asm.h b/arch/ia64/include/asm/mca_asm.h
> index dd2a5b1..d57d3c0 100644
> --- a/arch/ia64/include/asm/mca_asm.h
> +++ b/arch/ia64/include/asm/mca_asm.h
> @@ -46,11 +46,11 @@
>   *	1. Put 0x7 in bits 61 thru 63.
>   */
>  #define DATA_PA_TO_VA(addr,temp)							\
> -	mov	temp	= 0x7	;;							\
> +	mov	temp	= 0x7;							\

Double semicolons are significant in the ia64 assembler language.

> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index 4d40384..e187f1f 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -101,7 +101,7 @@ scm_version()
>  		# Are there uncommitted changes?
>  		# These are represented by + after the changeset id.
>  		case "$hgid" in
> -			*+|*+\ *) printf '%s' -dirty ;;
> +			*+|*+\ *) printf '%s' -dirty;

Double semicolons are significant in the Bourne shell language.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
