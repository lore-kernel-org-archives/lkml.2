Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab1IMV7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:59:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab1IMV7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:59:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	x-operating-system:user-agent:x-system-of-record;
	b=ZneUFuDlwzkCx+eAH0Wu6sx/vaPvtKIQjoaVIsw6S+TEVf6MW6bvaTnE3prnC/PiG
	cukhV1BPNEuIX6hjoZdcw==
Date: Tue, 13 Sep 2011 14:58:51 -0700
From: msb@google.com
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] lib/sha1.c: quite sparse noise about symbol not
 declared
Message-ID: <20110913215851.GD9560@google.com>
References: <201109091130.28110.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109091130.28110.hartleys@visionengravers.com>
X-Operating-System: Linux/2.6.32-gg508-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc linux-crypto, herbert, davem, torvalds

H Hartley Sweeten (hartleys@visionengravers.com) wrote:
> Include <linux/cryptohash.h> to pickup the declarations for sha_transform
> and sha_init to quite the sparse noise:
> 
> warning: symbol 'sha_transform' was not declared. Should it be static?
> warning: symbol 'sha_init' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> 

Acked-by: Mandeep Singh Baines <msb@chromium.org>

Thanks.

> ---
> 
> diff --git a/lib/sha1.c b/lib/sha1.c
> index f33271d..1de509a 100644
> --- a/lib/sha1.c
> +++ b/lib/sha1.c
> @@ -8,6 +8,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/bitops.h>
> +#include <linux/cryptohash.h>
>  #include <asm/unaligned.h>
>  
>  /*
