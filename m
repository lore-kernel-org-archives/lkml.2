Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab0GGC3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:29:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab0GGC3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:29:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100707014437.GA1851@infradead.org>
References: <20100624131455.GA10441@laptop>
	<7897.1277531612@jrobl>
	<20100626093544.GA27715@infradead.org>
	<13226.1277556884@jrobl>
	<20100705205806.GA12517@cynthia.pants.nu>
	<6419.1278372690@jrobl>
	<20100706004550.GC12517@cynthia.pants.nu>
	<AANLkTikoD1OPjVcyvAAJ0QO6dGJxv40Np6LgRQ7X4tMM@mail.gmail.com>
	<20100707014437.GA1851@infradead.org>
Date: Tue, 6 Jul 2010 19:28:12 -0700
Message-ID: <AANLkTikWredB5kF3iPhxIyGlyTDBM0DoMzn_eSc6rd6x@mail.gmail.com>
Subject: Re: [rfc] new stat*fs-like syscall?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Brad Boyer <flar@allandria.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
       Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 6:44 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
> I'm still waiting for Uli if he really insists on new syscall vectors
> for the same structure.  Using that one ST_VALID bit seems a lot easier
> to me.

Umm. Uli doesn't get to choose kernel system call conventions. It
matters not one whit whether he insists on new system calls or not,
it's not going to happen.

             Linus
