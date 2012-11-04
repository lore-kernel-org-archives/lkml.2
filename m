Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab2KDSOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 13:14:12 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:37734 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650Ab2KDSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 13:14:06 -0500
Message-ID: <1352052841.14888.190.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86: remove dummy long from EFI stub
From: Matt Fleming <matt@console-pimps.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Jordan Justen <jordan.l.justen@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Date: Sun, 04 Nov 2012 18:14:01 +0000
In-Reply-To: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
References: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-27 at 20:34 -0200, Cesar Eduardo Barros wrote:
> Commit 2e064b1 (x86, efi: Fix issue of overlapping .reloc section for
> EFI_STUB) removed a dummy reloc added by commit 291f363 (x86, efi: EFI
> boot stub support), but forgot to remove the dummy long used by that
> reloc.
> 
> Cc: Jordan Justen <jordan.l.justen@intel.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  arch/x86/boot/header.S | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 2a01744..8c132a6 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -476,6 +476,3 @@ die:
>  setup_corrupt:
>  	.byte	7
>  	.string	"No setup signature found...\n"
> -
> -	.data
> -dummy:	.long	0

This change seems fine to me. Jordan, would you mind ACKing this if
you're OK with it?

-- 
Matt Fleming, Intel Open Source Technology Center

