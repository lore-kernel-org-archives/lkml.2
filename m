Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1FQGhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 02:37:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1FQGhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 02:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=T6vafi5Z8MafrmJr5pxoMdJkUZFBzAO2Nc7QO92kTPZyfF2284aeefnP8yFPNCr2QB
         xvqIVlAShI9FRMX+tm+ZSHwgRRGalqWWO2kjg00ZRfMZZzLf5eZSJGSW/YVtQ0zbIlVa
         4oEc2yTP+7/Vlw18hHV3uSet7n9DSOfGgAdEM=
MIME-Version: 1.0
In-Reply-To: <1308187784-3815-1-git-send-email-asharma@fb.com>
References: <20110615163115.773d072e.akpm@linux-foundation.org> <1308187784-3815-1-git-send-email-asharma@fb.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 17 Jun 2011 02:36:56 -0400
Message-ID: <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 21:29, Arun Sharma wrote:
> --- a/arch/blackfin/include/asm/atomic.h
> +++ b/arch/blackfin/include/asm/atomic.h
> @@ -116,10 +116,7 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
>  #define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) == 0)
>  #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
>
> -#include <asm-generic/atomic-long.h>
>
>  #endif
>
> -#include <asm-generic/atomic64.h>
> -
>  #endif

i'm not sure this doesnt break things.  what tree exactly should i
apply this patch to to verify things ?
-mike
