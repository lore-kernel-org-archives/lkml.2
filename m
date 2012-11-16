Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2KPTpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:45:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:12084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2KPTph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:45:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,266,1352102400"; 
   d="scan'208";a="220796163"
Message-ID: <1353095127.25102.22.camel@jljusten-ivy>
Subject: Re: [PATCH] x86: remove dummy long from EFI stub
From: "Justen, Jordan L" <jordan.l.justen@intel.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Rosenbaum, Lee G" <lee.g.rosenbaum@intel.com>
Date: Fri, 16 Nov 2012 11:45:27 -0800
In-Reply-To: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
References: <1351377255-21092-2-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Jordan Justen <jordan.l.justen@intel.com>

Lee also tested with Secure Boot. (Thanks Lee)

-Jordan

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


