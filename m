Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0GGBou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:44:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0GGBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:44:49 -0400
Date: Tue, 6 Jul 2010 21:44:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brad Boyer <flar@allandria.com>, "J. R. Okajima" <hooanon05@yahoo.co.jp>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100707014437.GA1851@infradead.org>
References: <20100624131455.GA10441@laptop>
 <7897.1277531612@jrobl>
 <20100626093544.GA27715@infradead.org>
 <13226.1277556884@jrobl>
 <20100705205806.GA12517@cynthia.pants.nu>
 <6419.1278372690@jrobl>
 <20100706004550.GC12517@cynthia.pants.nu>
 <AANLkTikoD1OPjVcyvAAJ0QO6dGJxv40Np6LgRQ7X4tMM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikoD1OPjVcyvAAJ0QO6dGJxv40Np6LgRQ7X4tMM@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 06, 2010 at 09:45:26AM -0700, Linus Torvalds wrote:
> Let's not overdesign things. Just do something like the attached
> patch, which is the obvious and straightforward thing to do.
> 
> Overdesigning is a disease. It's fundamentally wrong.
> 
> (Yeah, yeah,. the patch is untested, and doesn't actually _fill_ the
> new f_flags value, but that's left as a trivial exercise for the
> reader.)

At least one of the readers posted a patch filling it in already.
Need to send out the version with the review comments addressed, but
I'm still waiting for Uli if he really insists on new syscall vectors
for the same structure.  Using that one ST_VALID bit seems a lot easier
to me.

