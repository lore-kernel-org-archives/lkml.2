Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0EaRhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:37:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56411 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab0EaRhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fCUxqHn1aAkq4AA/tnVXqdIpjgey49gXgGGF+wur4ccuyn7+Qw3vfauw7/LUFOiT9G
         nr5JGX0GrVAgRDEjXnZdCAPLJ1AYKgudHVPf19dIJr5F3c7+81tPVsHnQb2+bOgaB7g8
         Mt/79ErWS73WGr6+I8Yrp/8NnTd0escFFqIgI=
Message-ID: <4C03F3CA.6070809@gmail.com>
Date: Mon, 31 May 2010 19:37:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100520 SUSE/3.1rc1-1.1 Thunderbird/3.1
MIME-Version: 1.0
To: Spyros Papageorgiou <spyros.papageorgiou@gmail.com>
CC: gregkh@suse.de, devel@driverdev.osuosl.org,
       kernel-janitors@vger.kernel.org, ossama.othman@intel.com,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drivers: Stagins: memrar: cleanup
References: <4C03CFED.2030101@gmail.com>
In-Reply-To: <4C03CFED.2030101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 05:04 PM, Spyros Papageorgiou wrote:
> From:Spyros Papageorgiou <spyros.papageorgiou@gmai.com>
> 
> Removed an unneeded struct specifier in function call.
> 
> Signed-off-by: Spyros Papageorgiou <spyros.papageorgiou@gmai.com>
> ---
>  drivers/staging/memrar/memrar_allocator.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/memrar/memrar_allocator.c b/drivers/staging/memrar/memrar_allocator.c
> index a4f8c58..db37c6a 100644
> --- a/drivers/staging/memrar/memrar_allocator.c
> +++ b/drivers/staging/memrar/memrar_allocator.c
> @@ -276,7 +276,7 @@ long memrar_allocator_free(struct memrar_allocator *allocator,
>  
>  		struct memrar_address_range * const chunk =
>  			&list_entry(pos,
> -				    struct memrar_address_ranges,
> +				    memrar_address_ranges,
>  				    list)->range;

It is not a function call, it's a macro. Did you try to compile this?
