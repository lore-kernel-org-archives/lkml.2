Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab1ILJ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 05:59:15 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:46904
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1ILJ7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:59:14 -0400
Message-ID: <4E6DD7F0.8020903@kernel.dk>
Date: Mon, 12 Sep 2011 11:59:12 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: export __make_request
References: <20110911145053.GA28996@infradead.org>
In-Reply-To: <20110911145053.GA28996@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-11 16:50, Christoph Hellwig wrote:
> Avoid the hacks need for request based device mappers currently by simply
> exporting the symbol instead of trying to get it through the back door.

Good idea, lets rename it to blk_make_request() at the same time though.
I'll merge it as such.

-- 
Jens Axboe

