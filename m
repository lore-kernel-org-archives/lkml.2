Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1ILSEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:04:52 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:50578
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1ILSEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:04:48 -0400
Message-ID: <4E6E49BE.6020005@kernel.dk>
Date: Mon, 12 Sep 2011 20:04:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, bharrosh@panasas.com
Subject: Re: [PATCH 1/2] block: export __make_request
References: <20110911145053.GA28996@infradead.org> <4E6DD7F0.8020903@kernel.dk> <20110912122507.GA12229@infradead.org> <4E6DFA8C.3030400@kernel.dk> <20110912133826.GA22548@infradead.org>
In-Reply-To: <20110912133826.GA22548@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-12 15:38, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 02:26:52PM +0200, Jens Axboe wrote:
>>> What happens to the existing blk_make_request?
>>
>> I ended up naming __make_request() blk_queue_bio() instead.
> 
> I really hate naming things different from the method they are
> implementing.  I've tried to figure out what the point of the
> old blk_make_request is - why would we not go through
> generic_make_request for this?
> 
> Boaz, any idea?

I tend to agree, we could rename the existing blk_make_request(). It
could be blk_make_request_from_bio() or something like that, since
that's what it does.

-- 
Jens Axboe

