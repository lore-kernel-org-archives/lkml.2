Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1ILM0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:26:54 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:47615
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641Ab1ILM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:26:53 -0400
Message-ID: <4E6DFA8C.3030400@kernel.dk>
Date: Mon, 12 Sep 2011 14:26:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: export __make_request
References: <20110911145053.GA28996@infradead.org> <4E6DD7F0.8020903@kernel.dk> <20110912122507.GA12229@infradead.org>
In-Reply-To: <20110912122507.GA12229@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-12 14:25, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 11:59:12AM +0200, Jens Axboe wrote:
>> On 2011-09-11 16:50, Christoph Hellwig wrote:
>>> Avoid the hacks need for request based device mappers currently by simply
>>> exporting the symbol instead of trying to get it through the back door.
>>
>> Good idea, lets rename it to blk_make_request() at the same time though.
>> I'll merge it as such.
> 
> What happens to the existing blk_make_request?

I ended up naming __make_request() blk_queue_bio() instead.

-- 
Jens Axboe

