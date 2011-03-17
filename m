Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1CQKpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:45:40 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36391 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881Ab1CQKph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:45:37 -0400
Message-ID: <4D81E64F.2020909@kernel.dk>
Date: Thu, 17 Mar 2011 11:45:35 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: David Woodhouse <david.woodhouse@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20110314161919.15e6d983.sfr@canb.auug.org.au>	 <20110317103218.ca7f63bf.sfr@canb.auug.org.au> <4D81E010.1090808@kernel.dk> <1300358170.2589.50.camel@macbook.infradead.org>
In-Reply-To: <1300358170.2589.50.camel@macbook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-17 11:36, David Woodhouse wrote:
> On Thu, 2011-03-17 at 10:18 +0000, Jens Axboe wrote:
>>
>> Can you point me at the commit in question? Generally,
>> elv_queue_empty()
>> can be replaced by blk_peek_request(). 
> 
> The interesting commit is this one:
> http://git.infradead.org/mtd-2.6.git/commitdiff/c7519dbf6
> 
> The point of it is to enable this
> http://git.infradead.org/mtd-2.6.git/commitdiff/a32159024

OK, can you commit a change just changing that to blk_peek_request()?
That'll avoid the conflict.

-- 
Jens Axboe

