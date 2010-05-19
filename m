Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0ESMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:54:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0ESMyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:54:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CaW3Tj8qnsMuBEzFvfxiuECrCxddW7NnOAJnubhbzrZIZ7OhLsqahr8y98/WWklysg
         pI3yJTC/KRB2eTv4KQXRyjRf+AdJ9b6IWJ6c7F//yCb5iMt9HBB3w4rbBGxL6lkpKQ65
         exRX8bxyD6FdVPyBh2EAd0ZCWTukB351A5ChA=
MIME-Version: 1.0
In-Reply-To: <20100519114609.GA26610@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274266725.6930.9823.camel@macbook.infradead.org>
	 <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
	 <1274267805.6930.9877.camel@macbook.infradead.org>
	 <20100519114609.GA26610@gondor.apana.org.au>
Date: Wed, 19 May 2010 15:54:43 +0300
X-Google-Sender-Auth: jVarNME7ZSQjIeW4lFMqFAGQgX4
Message-ID: <AANLkTiky-saTpv6Vq2ipIWC39b5eox92qQGE0QcACEBR@mail.gmail.com>
Subject: Re: [BUG] SLOB breaks Crypto
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>, David Miller <davem@davemloft.net>,
       mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
       michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 2:46 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, May 19, 2010 at 12:16:45PM +0100, David Woodhouse wrote:
>>
>> I don't mind. Feel free to apply them to slab.git, but be aware that
>> Herbert wanted to see a patch fixing sparc32 ARCH_SLAB_MINALIGN before
>> the crypto one is applied.
>>
>> Although arguably SLOB was broken on sparc32 even before the crypto
>> patch -- so perhaps that fix shouldn't _have_ to go in first?
>
> Well prior to this crypto on sparc32 did work with SLAB/SLUB.  If
> you change it without including the sparc pach, then sparc32 would
> be broken regardless of which allocator you used.

OK, I'll pick up David's patches and just wait for sparc changes to
hit Linus' tree first. Herbert, do I have your ACK for the crypto
patches?
