Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965589Ab2EOPrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:47:08 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51933 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab2EOPrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:47:06 -0400
Date: Tue, 15 May 2012 12:46:59 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Perf events warning..
Message-ID: <20120515154659.GA7864@infradead.org>
References: <CA+55aFzNQqa9nuhZUog-+B0SfU6ip_QSt73R=2Du=M2ua1cFBA@mail.gmail.com>
 <1337034048.27020.137.camel@laptop>
 <CA+55aFxHw_SOX7fvcwskwP0qvLwyeXxTFjk589pnQtmYevhvpw@mail.gmail.com>
 <1337078996.27694.26.camel@twins>
 <4FB2755F.9020606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB2755F.9020606@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 15, 2012 at 09:25:19AM -0600, David Ahern escreveu:
> Perhaps it is specific to processor generation? Yesterday I noted
> that perf-stat -g trips a WARNING only on Nehalem. Westmere works
> fine - perf-stat -g generates output and no warning is triggered.
> Arnaldo is using Sandy Bridge - though it's not clear if his success
> (3.4.0-rc3 on server named sandy) or fail (3.4.0-rc4-uprobes on
> felicio) was on a SNB.

Both are sandy bridges, sandy is a notebook (Intel(R) Core(TM)
i7-2920XM), felicio is a desktop (Intel(R) Core(TM) i5-2400).

- Arnaldo
