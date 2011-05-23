Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1EWH1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:27:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1EWH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:27:07 -0400
Date: Mon, 23 May 2011 03:27:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Adding an ugliness in __read_cache_page()?
Message-ID: <20110523072705.GA3966@infradead.org>
References: <alpine.LSU.2.00.1105221518180.17400@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1105221518180.17400@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 22, 2011 at 03:25:31PM -0700, Hugh Dickins wrote:
> I find both ways ugly, but no nice alternative: introducing a new method
> when the known callers are already tied to tmpfs/ramfs seems over the top.

Calling into shmem directly is the less ugly variant.  Long term killing
that tmpfs abuse would be even better, but I already lost that fight
when it was initially added.

