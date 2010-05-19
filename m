Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0ESLIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:08:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54909 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0ESLIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:08:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KmP8IQ0najhKkHAu/2ZXWQkDYMLUBRN/xt6x2i2jkEA8G28Gd3qEoL5ikd3PXXk10B
         96ddZvh3t6Z/Iwy5dJDJi7PIgW7VEov3QP/HMttW0K1OswsH9snOkXUgyVFXcSoieKqv
         xJTZoju7c1+mKpY5Iq1ux0iEUsBd9BrcnGSYU=
MIME-Version: 1.0
In-Reply-To: <1274266725.6930.9823.camel@macbook.infradead.org>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274266725.6930.9823.camel@macbook.infradead.org>
Date: Wed, 19 May 2010 14:08:41 +0300
X-Google-Sender-Auth: RANjlMaWAHntjJjuIDBOZ0Jp994
Message-ID: <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       David Miller <davem@davemloft.net>, mpm@selenic.com, ken@codelabs.ch,
       geert@linux-m68k.org, michael-dev@fami-braun.de,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 1:58 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-05-19 at 11:05 +1000, Herbert Xu wrote:
>> So no getting rid of them isn't going to fix things either.  Of
>> course I have no objections to moving this into slab.h or a similar
>> location should anyone be willing to do the hard work.
>
> http://git.infradead.org/users/dwmw2/minalign-2.6.git
> git://git.infradead.org/users/dwmw2/minalign-2.6.git

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Are you sending the patches to Linus or do you want me to pull them in slab.git?
