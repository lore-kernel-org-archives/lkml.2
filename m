Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab1IOLzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:55:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60446
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933214Ab1IOLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:55:45 -0400
Date: Thu, 15 Sep 2011 07:55:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/2] block: refactor generic_make_request
Message-ID: <20110915115534.GA14819@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <20110912134202.GA22953@infradead.org>
 <20110912150935.GA27453@redhat.com>
 <20110912151310.GA7188@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912151310.GA7188@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 11:13:10AM -0400, Christoph Hellwig wrote:
> > > @@ -1557,16 +1561,15 @@ void generic_make_request(struct bio *bi
> > >  	 * from the top.  In this case we really did just take the bio
> > >  	 * of the top of the list (no pretending) and so remove it from
> > >  	 * bio_list, and call into __generic_make_request again.
> >                                    ^^^^^^^^^^
> > You got rid of __generic_make_request(). Now above comment has stale
> > reference to it.
> 
> Yeah, this should be ->make_request now.

Jens, do you want me to resend with that fix or can you fix it up when
applying?
