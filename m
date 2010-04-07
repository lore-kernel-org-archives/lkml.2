Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0DGXp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:45:58 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50170 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0DGXpz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AmBbQOox59MaQ7wqetiQ5RbTr7KPWRUb3iYz6HzCiF/doyjl4KB9IWpZbXvtP6NuiR
         pXKkz7Qr98Ba5NvJnIBzcZ5dhTsYYxpfsDcYgLqkcqwXj7nFB0WJliXfhWGeTZfdUl/e
         /JdfSzvRdj4C7eD87uPOYesVofS1+1Iq+lq28=
MIME-Version: 1.0
In-Reply-To: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
References: <1270681920-4461-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 7 Apr 2010 16:45:54 -0700
X-Google-Sender-Auth: 65dd6ff7654fc8f1
Message-ID: <v2se9c3a7c21004071645u8180f4d7p3b4b1f96de11303e@mail.gmail.com>
Subject: Re: [PATCH 00/11] ARM: PrimeCell DMA Interface v5
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, back online now.

On Wed, Apr 7, 2010 at 4:12 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This is the fifth iteration of this ever growing patch set
> for PrimeCell DMA support, reposting the entire series.
>
> This now depend on stuff pending in Dan Williams async_tx
> (DMA Devices/Engine) tree and Andrew Mortons tree where
> the new DMA40 driver for U8500 is queued.
>
> I suggest putting these into Andrews tree now, since:
>
> A) 4 of the patches it touches MMCI code which is hanled
>   by Andrew
>

Ok, but it looks like they do not have a build dependency on dma bits
so they could be merged separately i.e. on top of the async_tx branch.

> B) It extends the DMA40 driver which is now pending in
>   his tree as well.
>
> C) Since there doesn't seem to be any consensus of whether
>   this is the right way forward, it needs some wider
>   testing I believe.

No consensus with respect to which pieces, the Primecell driver or
something outside of drivers/dma?  Forgive me for missing recent
conversations if this has been discussed to death already.

> OK?

I can go ahead and queue up the dma bits unless you would prefer, and
Andrew agrees, to take this all through the -mm tree?

--
Dan
