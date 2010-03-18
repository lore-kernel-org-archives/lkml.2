Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0CRRBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:01:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:41705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0CRRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=mpXvgFS36QLJSEzjaADdkUlCrFHRUQAXbKuqQ/Rb+lupTs4t17yPV85+ZKvZBHsIQx
         7TuJT+k2DW6nzXAsg8bjl2/e4nDaVfut71ZriIwb4LIEnALjVw3phz0bri5dGrr4a/g3
         Fyt18yvLJo5GQO+HKUz4lljFwMooxsbJdnHpM=
MIME-Version: 1.0
In-Reply-To: <4B9E38AF.70309@fami-braun.de>
References: <4B9E38AF.70309@fami-braun.de>
Date: Thu, 18 Mar 2010 18:30:54 +0200
X-Google-Sender-Auth: 2a3400a13d324dc3
Message-ID: <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: michael-dev@fami-braun.de
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 3:39 PM,  <michael-dev@fami-braun.de> wrote:
> Hi,
>
> I've been trying to get Linux Kernel Crypto up&running
> on an AMD Geode LX board (Alix 2d2) but instantly
> experienced a huge amount of errors that look much like
> general memory corruption. Among them where NULL-pointer errors in
> net/core/dst.c, ath9k_skb_.*, net_skb.*, page table corruption,
> NULL-pointer errors in add_swap.* (with no swap installed at all) and
> many more. These errors could be trigger by loading tcrypt for any
> installed algorithm severeal times or by loading tcrypt without
> paramters or by compiling crypto statically into the kernel or by
> installing and loading cryptodev or ocf-linux.
>
> I've had the system configured with SLOB and all memory debugging
> enabled. All of these errors instantly disappeared when switching back
> to SLAB.

Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
CONFIG_SLUB_DEBUG_ON?
