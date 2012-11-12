Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2KLVaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:30:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab2KLVau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:30:50 -0500
Message-ID: <50A16A7E.5030207@kernel.dk>
Date: Mon, 12 Nov 2012 14:30:38 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: linux-next: manual merge of the akpm tree with the block tree
References: <20121112151540.16dd14cd1eef76432c098e8a@canb.auug.org.au> <20121112130727.e063fa37.akpm@linux-foundation.org> <50A16811.10503@kernel.dk> <20121112132901.4bd52e6f.akpm@linux-foundation.org>
In-Reply-To: <20121112132901.4bd52e6f.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-12 14:29, Andrew Morton wrote:
> On Mon, 12 Nov 2012 14:20:17 -0700
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 2012-11-12 14:07, Andrew Morton wrote:
>>> On Mon, 12 Nov 2012 15:15:40 +1100
>>> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>>> Hi Andrew,
>>>>
>>>> Today's linux-next merge of the akpm tree got a conflict in
>>>> drivers/memstick/core/ms_block.h between commit 0604fa04ccc7 ("memstick:
>>>> add support for legacy memorysticks") that use to be in the block tree
>>>> and commits "memstick: remove unused field from state struct", "memstick:
>>>> ms_block: fix compile issue", "memstick: use after free in
>>>> msb_disk_release()" and "memstick: memory leak on error in msb_ftl_scan
>>>> ()" from the akpm tree.
>>>>
>>>> The block tree commit has been dropped, so the 4 akpm tree patches no
>>>> longer have anything to apply to, so I have dropped them.
>>>
>>> Confused.  Who dropped "memstick: add support for legacy memorysticks"?
>>> You, or Jens?
>>
>> I dropped it for 3.7 submission, that's why it disappeared from my
>> for-next.
> 
> But linux-next is the candidate 3.8 tree, so the memstick patches
> should be in there.  Or did you mean "3.8"?

Agree, and it is holding 3.8 stuff, memstick just wasn't added back
yet...

-- 
Jens Axboe

