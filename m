Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1ILM0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:26:07 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:47606
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab1ILM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:26:04 -0400
Message-ID: <4E6DFA5B.1000305@kernel.dk>
Date: Mon, 12 Sep 2011 14:26:03 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-raid@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: remove support for bio remapping from ->make_request
References: <20110911145053.GA28996@infradead.org> <20110911145129.GA29504@infradead.org> <4E6DD818.80902@kernel.dk> <20110912122528.GB12229@infradead.org>
In-Reply-To: <20110912122528.GB12229@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-12 14:25, Christoph Hellwig wrote:
> On Mon, Sep 12, 2011 at 11:59:52AM +0200, Jens Axboe wrote:
>> On 2011-09-11 16:51, Christoph Hellwig wrote:
>>> There is very little benefit in allowing to let a ->make_request
>>> instance update the bios device and sector and loop around it in
>>> __generic_make_request when we can archive the same through calling
>>> generic_make_request from the driver and letting the loop in
>>> generic_make_request handle it.
>>
>> Agree, this looks good! Will apply for 3.2.
> 
> Are you going to fix the issue Neil pointed out beforehand?

Yep, I merged that one in with the 2/2 patch and added his Acked-by as
well.

-- 
Jens Axboe

