Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1ILNib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:38:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37098
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756003Ab1ILNi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:38:29 -0400
Date: Mon, 12 Sep 2011 09:38:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        bharrosh@panasas.com
Subject: Re: [PATCH 1/2] block: export __make_request
Message-ID: <20110912133826.GA22548@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <4E6DD7F0.8020903@kernel.dk>
 <20110912122507.GA12229@infradead.org>
 <4E6DFA8C.3030400@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6DFA8C.3030400@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 02:26:52PM +0200, Jens Axboe wrote:
> > What happens to the existing blk_make_request?
> 
> I ended up naming __make_request() blk_queue_bio() instead.

I really hate naming things different from the method they are
implementing.  I've tried to figure out what the point of the
old blk_make_request is - why would we not go through
generic_make_request for this?

Boaz, any idea?
