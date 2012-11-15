Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768950Ab2KOUYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:24:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35275 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768917Ab2KOUYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:24:16 -0500
Date: Thu, 15 Nov 2012 21:24:11 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, bp@alien8.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h
 processors
Message-ID: <20121115202411.GA6520@tweety>
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 01:41:50PM -0500, Boris Ostrovsky wrote:
> Add valid patch size for family 16h processors
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>


Acked-by: Andreas Herrmann <herrmann.der.user@googlemail.com>


Thanks,
Andreas

> ---
>  arch/x86/kernel/microcode_amd.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> index 7720ff5..58790e8 100644
> --- a/arch/x86/kernel/microcode_amd.c
> +++ b/arch/x86/kernel/microcode_amd.c
> @@ -190,6 +190,7 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
>  #define F1XH_MPB_MAX_SIZE 2048
>  #define F14H_MPB_MAX_SIZE 1824
>  #define F15H_MPB_MAX_SIZE 4096
> +#define F16H_MPB_MAX_SIZE 3458
>  
>  	switch (c->x86) {
>  	case 0x14:
> @@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32 patch_size,
>  	case 0x15:
>  		max_size = F15H_MPB_MAX_SIZE;
>  		break;
> +	case 0x16:
> +		max_size = F16H_MPB_MAX_SIZE;
> +		break;
>  	default:
>  		max_size = F1XH_MPB_MAX_SIZE;
>  		break;
> -- 
> 1.7.10.4
> 
> 
