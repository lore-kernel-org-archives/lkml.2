Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2G3Ulk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 16:41:40 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62108 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab2G3Ulh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 16:41:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207301255320.24196@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2>
	<CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com>
	<alpine.DEB.2.00.1207301255320.24196@chino.kir.corp.google.com>
Date: Mon, 30 Jul 2012 23:41:35 +0300
X-Google-Sender-Auth: -mbslhmMNO19MnZk5nSFHR4ZlWI
Message-ID: <CAOJsxLHw8G0ChnOeBv1nNr3tqNPPjdnkY=RStyo3rRqC1bdDAA@mail.gmail.com>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: shuah.khan@hp.com, cl@linux.com, glommer@parallels.com, js1304@gmail.com,
        shuahkhan@gmail.com, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 10:56 PM, David Rientjes <rientjes@google.com> wrote:
> -Wunused-label is overridden in gcc for a label that is conditionally
> referenced by using __maybe_unused in the kernel.  I'm not sure what's so
> obscure about
>
> out: __maybe_unused
>
> Are label attributes really that obsecure?

I think they are.

The real problem, however, is that label attributes would just paper
over the badly thought out control flow in the function and not make the
code any better or easier to read.

                        Pekka
