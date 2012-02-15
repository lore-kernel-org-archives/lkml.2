Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2BOTV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:21:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39887 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2BOTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:20:56 -0500
Message-ID: <4F3C0588.1080601@gmail.com>
Date: Wed, 15 Feb 2012 13:20:40 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Grant Likely <grant.likely@secretlab.ca>, Danny Kukawka <dkukawka@suse.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/fdt.c: asm/setup.h included twice
References: <1329328528-4847-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329328528-4847-1-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2012 11:55 AM, Danny Kukawka wrote:
> drivers/of/fdt.c included 'asm/setup.h' twice, remove the duplicate.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Applied for 3.4.

Rob

> ---
>  drivers/of/fdt.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index ea2bd1b..91a375f 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -23,7 +23,6 @@
>  #include <asm/machdep.h>
>  #endif /* CONFIG_PPC */
>  
> -#include <asm/setup.h>
>  #include <asm/page.h>
>  
>  char *of_fdt_get_string(struct boot_param_header *blob, u32 offset)
