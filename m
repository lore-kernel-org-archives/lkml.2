Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1CQIBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:01:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50709 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab1CQIBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jWQDBeHGfI+dsmF67Bc36IlC8/krO2OE8NDilNTsO9LQp+GLvsafzdj1Cla7xOYm+l
         2n0M9uWrJPDU4S09H6kTLMxp3QcNOIQWbvdfkyxs7/+1aVXOtq/hkfgFWWO+nZ0OMXBv
         qzmqbt1gOwp+IAeP/u4vMbJVir3Ty7z2hNiw4=
MIME-Version: 1.0
In-Reply-To: <20110317070705.15100.qmail@science.horizon.com>
References: <AANLkTikDAEuTcrgo0YcUO40A9x5jaL-d+ZPviCXANe3r@mail.gmail.com>
	<20110317070705.15100.qmail@science.horizon.com>
Date: Thu, 17 Mar 2011 10:01:44 +0200
X-Google-Sender-Auth: T46cGFNYmO0n4O7tlWkW25F80wo
Message-ID: <AANLkTinsiWXHtrU0aN1Fsavs-2M2VD=vRYLjNhLQiO0s@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/slub: Factor out some common code.
From: Pekka Enberg <penberg@kernel.org>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi,
        rientjes@google.com, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 9:07 AM, George Spelvin <linux@horizon.com> wrote:
>> I certainly don't but I'd still like to ask you to change it to
>> 'unsigned long'. That's a Linux kernel idiom and we're not going to
>> change the whole kernel.
>
> Damn, and I just prepared the following patch.  Should I, instead, do
>
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -62,5 +62,5 @@ struct kmem_cache {
>  /* 3) touched by every alloc & free from the backend */
>
> -       unsigned int flags;             /* constant flags */
> +       unsigned long flags;            /* constant flags */
>        unsigned int num;               /* # of objs per slab */
>
> ... because the original slab code uses an unsigned int.

Looks good to me.
