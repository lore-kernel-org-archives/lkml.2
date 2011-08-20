Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1HTRlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:41:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50517
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab1HTRlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:41:40 -0400
Date: Sat, 20 Aug 2011 13:41:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 3.1-rc
Message-ID: <20110820174137.GA27243@infradead.org>
References: <4E4E6238.3080808@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4E6238.3080808@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 03:16:40PM +0200, Jens Axboe wrote:
> - Revert of the CFQ meta data special treatment patch, it's been shown
>   to regress a kernel build workload by about 10%. More investigation
>   is needed, for 3.1 lets just back it out.

Sorry, but you can't simply do that without any coordination.  We have
added that marker to xfs now that the stupid special casing stopped,
and turning it back on will cause us massive slowdows.  Next time
please better coordinate this with its users.  In fact I have never
seen this patch or a discussion on any mailinglist.

