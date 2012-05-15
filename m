Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2EOKuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:50:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2EOKuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:50:03 -0400
Message-ID: <1337078996.27694.26.camel@twins>
Subject: Re: Perf events warning..
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 12:49:56 +0200
In-Reply-To: <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
	 <1337034048.27020.137.camel@laptop>
	 <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 15:25 -0700, Linus Torvalds wrote:
> On Mon, May 14, 2012 at 3:20 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > So far I can't make any of the things I came up stick. You ran something
> > simple like: 'perf record -e cycles:pp -F 20000 make test' ? Or did you
> > do something more interesting?
> 
> It was not much more complex than that.
> 
> It did use "make -j64 test" to make the load a *bit* more interesting
> (and go noticeably faster), but other than that you got it.

OK, that limits the scope of crazy scenarios I have to consider, still
no immediate clue though..

I think I've found a possible race, but I can't make it work with that
workload. I've also let your workload run for 2+ hours in trying to
reproduce, but no luck, it must be a very narrow window indeed.

I'll keep prodding at it..
