Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1ILMZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:25:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:48515
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755685Ab1ILMZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:25:29 -0400
Date: Mon, 12 Sep 2011 08:25:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from
 ->make_request
Message-ID: <20110912122528.GB12229@infradead.org>
References: <20110911145053.GA28996@infradead.org>
 <20110911145129.GA29504@infradead.org>
 <4E6DD818.80902@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6DD818.80902@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 11:59:52AM +0200, Jens Axboe wrote:
> On 2011-09-11 16:51, Christoph Hellwig wrote:
> > There is very little benefit in allowing to let a ->make_request
> > instance update the bios device and sector and loop around it in
> > __generic_make_request when we can archive the same through calling
> > generic_make_request from the driver and letting the loop in
> > generic_make_request handle it.
> 
> Agree, this looks good! Will apply for 3.2.

Are you going to fix the issue Neil pointed out beforehand?

