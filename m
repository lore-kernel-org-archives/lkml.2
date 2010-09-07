Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0IGO5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:57:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32955 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab0IGO5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:57:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xZA6e11tyr3vDjbyYzysLMfhhGlhUcjyAwiUOGz37E6RQftVArj7xjWx0uIp4/PTO0
         pBdXvSmkclbRt4OuqR2ZoU92DBUJUw82WSkdmk4F712moBGaGsUAt/5KD13hYvi18ZqP
         MC8okVJfdPy5j78Rj6wRuItnFcvjmLQZ9CQY4=
MIME-Version: 1.0
In-Reply-To: <20100907140646.GA31921@infradead.org>
References: <20100907084213.GA4610@gondor.apana.org.au>
	<20100907140646.GA31921@infradead.org>
Date: Tue, 7 Sep 2010 16:57:04 +0200
X-Google-Sender-Auth: KKF43ZVbr-GkoVrJYneBIkwGNgU
Message-ID: <AANLkTinfQprsNC2ipocUKUWv894mbVtnDoxd5as9kCt-@mail.gmail.com>
Subject: Re: RFC: Crypto API User-interface
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 4:06 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> This is what I am proposing for the Crypto API user-interface.
>
> Can you explain why we would ever want a userspace interface to it?
>
> doing crypto in kernel for userspace consumers sis simply insane.
> It's computational intensive code which has no business in kernel space
> unless absolutely required (e.g. for kernel consumers).  In addition
> to that adding the context switch overhead and address space transitions
> is god awfull too.
> This all very much sounds like someone had far too much crack.

Or that someone is not really aware of some cryptographic uses.
Embedded systems have crypto accelerators in hardware available
through kernel device drivers. In the systems I worked the
accelerators via a crypto device interface gave a 50x to 100x boost in
crypto operations and relieved the CPU from doing them.

regards,
Nikos
