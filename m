Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KXK0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 05:26:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab0KXK0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 05:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kqZH3e1LgIInQAs1DhToqwNdaehFahwngbFXclnSEN4Y5qE06ryQkTvwLC1p/ZmQKV
         rNQbk+FNDkD82rSLqJ3FoFnFo3HcA3BGZq9E6FlLEBMVIzunrFN6YpMUU6HDeMrycayI
         xHOqmXtwLo95rYdZHT/Fp2v/4d2xOm4M/AxBA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
	<alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
Date: Wed, 24 Nov 2010 16:26:01 +0600
Message-ID: <AANLkTinOAdDqmVo+zrEk=-EUri-CXBY1kukd96-ocHhL@mail.gmail.com>
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 3:57 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Wed, 24 Nov 2010, Rakib Mullick wrote:
>
>
> So, now the bp variable does not exist at all if CONFIG_FRAME_POINTER is
> not defined.

Yes - right. And its not used outside CONFIG_FRAME_POINTER.

> That's going to make this line :
>
>          show_trace(NULL, NULL, &stack, bp);
>
Not clear what are you trying to say. Would you please, clear it up a bit?

> found further down in the dump_stack() function, quite unhappy.
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
