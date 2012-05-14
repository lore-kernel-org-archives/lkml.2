Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab2ENW00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:26:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50028 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab2ENW0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <1337034048.27020.137.camel@laptop>
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
 <1337034048.27020.137.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 May 2012 15:25:59 -0700
X-Google-Sender-Auth: 9Q-qNjcaCMcPuxOhFT5xZsyyo80
Message-ID: <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
Subject: Re: Perf events warning..
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 3:20 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So far I can't make any of the things I came up stick. You ran something
> simple like: 'perf record -e cycles:pp -F 20000 make test' ? Or did you
> do something more interesting?

It was not much more complex than that.

It did use "make -j64 test" to make the load a *bit* more interesting
(and go noticeably faster), but other than that you got it.

                     Linus
