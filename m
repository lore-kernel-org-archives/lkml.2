Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1HUSTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 14:19:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41115
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab1HUSTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 14:19:38 -0400
Date: Sun, 21 Aug 2011 14:19:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 3.1-rc
Message-ID: <20110821181935.GA28979@infradead.org>
References: <4E4E6238.3080808@fusionio.com>
 <20110820174137.GA27243@infradead.org>
 <4E5146C1.508@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5146C1.508@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 07:56:17PM +0200, Jens Axboe wrote:
> The discussion was on lkml, as Mike points out. But yes, short time to
> react. Since I can't easily cater to both cases right now, how about we
> add a temporary second meta flag that is only used for tracing?
> 
>         REQ_META        = (__REQ_META | __REQ_META_TRACE),
>         RET_META_TRACE  = __REQ_META_TRACE,
> 
> You get the idea. Not super pretty, but it should solve the immediate
> issue.

I'd do it the other way around and add a new REQ_META_BOOST flag to
the old callers.  I'll cook up a patch on the airport / on my flight
if you want.

