Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2JHTIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 15:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab2JHTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 15:08:52 -0400
Date: Mon, 8 Oct 2012 21:10:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [regression] boot failure on alpha, bisected
Message-ID: <20121008191004.GA10306@redhat.com>
References: <20121006204736.GA1830@ds20.borg.net> <20121007165534.GA8024@redhat.com> <20121007171300.GA10942@redhat.com> <20121007180420.GA900@ds20.borg.net> <20121007191627.GA19278@redhat.com> <CAMuHMdUjqogJ5Db1wCZz4v6OEutDPbcF0a=zc=ZCJS7-8rYDqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUjqogJ5Db1wCZz4v6OEutDPbcF0a=zc=ZCJS7-8rYDqw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Geert Uytterhoeven wrote:
>
> Just wondering. As this is on an SMP system, perhaps the
> read_barrier_depends() vs. smp_read_barrier_depends() matters
> here?
> http://lkml.indiana.edu/hypermail/linux/kernel/1209.3/00555.html

Yes, thanks, I do remember about this ;)

This will come as 2/2 which also removes the unnecessary "work = NULL"
initialization.

Oleg.

