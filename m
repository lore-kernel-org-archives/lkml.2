Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1AJMMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:12:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39455 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab1AJMMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:12:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PP1cEIFv4Gq8ftxrTLoffWGVjYt3Bh40rOl9LM2B3wt3m6WiHBYvO9iwiUY+cMU217
         xpncyE3aO+nlLuVUA0x/GGj6b1Kwm4NGgHM+7ddm9jiXjIFqBbGYT7x9lHRuo9dJHp2M
         54ILeHdSddd4Ef0baZ9FldKc3QPZ5+/KxN6sI=
MIME-Version: 1.0
In-Reply-To: <201101101244.24932.christoph.paasch@uclouvain.be>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	<1294614389.2823.35.camel@localhost>
	<AANLkTik7mug7j=VLz80DX_hJokeO3=ie+KRcMViSL4kB@mail.gmail.com>
	<201101101244.24932.christoph.paasch@uclouvain.be>
Date: Mon, 10 Jan 2011 14:12:46 +0200
Message-ID: <AANLkTim0U22b+S=9qZj5BP5TTxEM=U2BhpO4ZjfQAuOz@mail.gmail.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
From: Alexey Dobriyan <adobriyan@gmail.com>
To: christoph.paasch@uclouvain.be
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/10 Christoph Paasch <christoph.paasch@uclouvain.be>:
>
> On Monday, January 10, 2011 wrote Alexey Dobriyan:
>> >> linux/percpu_counter.h (needed for percpu_counter_sum_positive)
>> >
>> > Yes.
>>
>> Currently code compiles fine, so necessary headers are in place,
>> so simply adding new headers doesn't help anything.
>
> I totally agree with you.
> However we need a consistent coding style.
>
> Or we just include the minimum necessary headers (as originally proposed by
> me).
> Or we include every header whose structs/functions are referenced.

This is false dichotomy and extreme siding.

We need code that compiles.
We need headers to include realistically minimum amount of stuff (not
#include lines,
but stuff)

> In my opinion the current "mixed" state is not ok, because some includes are
> there because there *are* references (even if these includes could be omitted,
> e.g., linux/list.h).
> Other includes (like linux/percpu_counter.h) are not there, because they are
> indirectly included by another header and thus the code compiles. Even if
> there are references.
> And there are no rules/guidelines to identify the headers that should be
> included and those that should not.

That because the issue not that important. :-)
