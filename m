Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab1DKMeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 08:34:14 -0400
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:47005 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1DKMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 08:34:14 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Q. locking order of dcache_lru_lock
To: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1302510651.2388.8.camel@twins>
References: <9769.1302268831@jrobl> <1302369133.2388.1.camel@twins> <29946.1302498571@jrobl> <1302510651.2388.8.camel@twins>
Date: Mon, 11 Apr 2011 21:33:52 +0900
Message-ID: <9823.1302525232@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Peter Zijlstra:
> Not really a problem, locking order is simply a tool/scheme to avoid
> deadlocks. Since there is no deadlock potential its fine to 'violate'
> locking order.

I see.
Then lockdep always ignore all tyrlocks?

Thank you for answering.

J. R. Okajima
