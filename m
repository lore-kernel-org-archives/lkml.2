Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1DKFKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 01:10:06 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:42525 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1DKFKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 01:10:01 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Q. locking order of dcache_lru_lock
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1302369133.2388.1.camel@twins>
References: <9769.1302268831@jrobl> <1302369133.2388.1.camel@twins>
Date: Mon, 11 Apr 2011 14:09:31 +0900
Message-ID: <29946.1302498571@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra:
> On Fri, 2011-04-08 at 22:20 +0900, J. R. Okajima wrote:
> >=20
> > When spin_trylock(&dentry->d_lock) successfully acquired d_lock, does
> > the violation of locking order happen (or a deadlock, in worse case)?=20
>
> No, since a trylock never actually blocks a deadlock cannot occur.

Ah, exactly. I had to be sleeping when I wrote about deadlock.
How about the locking order? Do you think d_lock after dcache_lru_lock
is a problem?


J. R. Okajima
