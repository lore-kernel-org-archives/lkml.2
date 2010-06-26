Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab0FZJfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 05:35:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0FZJfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 05:35:48 -0400
Date: Sat, 26 Jun 2010 05:35:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
Message-ID: <20100626093544.GA27715@infradead.org>
References: <20100624131455.GA10441@laptop>
 <7897.1277531612@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7897.1277531612@jrobl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 02:53:32PM +0900, J. R. Okajima wrote:
> 
> Nick Piggin:
> > Is there anything more we should add here? Samba wants a capabilities
> > field, with things like sparse files, quotas, compression, encryption,
> > case preserving/sensitive.
> 
> How about the max link count?
> There was a post in last December.
> See <http://marc.info/?l=linux-kernel&m=126008640210762&w=2> and its
> thread in detail.

That's really job for a pathconf system call that allows quering random
paramters.

