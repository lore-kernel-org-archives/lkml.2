Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1C1GZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:25:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49402 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1C1GZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=n3LWADv1XonafgY4LmQQ70s3C0HxjgZQEM6cS7nXHO/4XzzD9sfDRBB/0iDcTqHxet
         LdJ9IDwem1tBlu/6VlXFVTHW+dfdZOyD+n/AM8Ek41zhACf7Jxdk6y+FUloFfxPyWQFM
         9lp/ujmOZyXsf4FYRCMV/0R3EffOt4qUyJe80=
MIME-Version: 1.0
In-Reply-To: <20110328061929.GA24328@elte.hu>
References: <20110326112725.GA28612@elte.hu>
	<20110326114736.GA8251@elte.hu>
	<1301161507.2979.105.camel@edumazet-laptop>
	<alpine.DEB.2.00.1103261406420.24195@router.home>
	<alpine.DEB.2.00.1103261428200.25375@router.home>
	<alpine.DEB.2.00.1103261440160.25375@router.home>
	<AANLkTinTzKQkRcE2JvP_BpR0YMj82gppAmNo7RqgftCG@mail.gmail.com>
	<alpine.DEB.2.00.1103262028170.1004@router.home>
	<alpine.DEB.2.00.1103262054410.1373@router.home>
	<4D9026C8.6060905@cs.helsinki.fi>
	<20110328061929.GA24328@elte.hu>
Date: Mon, 28 Mar 2011 09:25:13 +0300
X-Google-Sender-Auth: -lXqpYFn5NplFpEhV4sTjhmGX1I
Message-ID: <AANLkTinpCa6GBjP3+fdantvOdbktqW8m_D0fGkAnCXYk@mail.gmail.com>
Subject: Re: [PATCH] slub: Disable the lockless allocator
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        tj@kernel.org, npiggin@kernel.dk, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 9:19 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> Tejun, does this look good to you as well? I think it should go
>> through the percpu tree. It's needed to fix a boot crash with
>> lockless SLUB fastpaths enabled.
>
> AFAICS Linus applied it already:
>
> d7c3f8cee81f: percpu: Omit segment prefix in the UP case for cmpxchg_double

Oh, I missed that. Did you test the patch, Ingo? It's missing
attributions and reference to the LKML discussion unfortunately...
