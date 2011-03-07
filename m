Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1CGLZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:25:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50786 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab1CGLZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:25:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=B8Havh8OnU9CLLOXVFYyZa7f29A9LO4ev97W6I14FUmeCVguARRWod/F/1YCKJE9ye
         x65+7I6k093teIdQskJKufoEsRYM5kjTLsIywtmkntN8Jf4NWQ+0X++1q4A7dzxOiEg9
         Q8Xe3Jv47ItHmj91hfs+LegWxrEWsSCy0s3m0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D74BE7C.4050701@kernel.dk>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
	<20110307063618.GA10365@mtj.dyndns.org>
	<4D749A81.50809@kernel.dk>
	<AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
	<20110307104747.GH20499@htj.dyndns.org>
	<AANLkTinBx5Z9Gp7ZTcbbTMCZZ4Z68-vMBP9yOX-k15EA@mail.gmail.com>
	<4D74BE7C.4050701@kernel.dk>
Date: Mon, 7 Mar 2011 12:25:23 +0100
Message-ID: <AANLkTi=9AUSv0rJtudgnEBERaCLpyHhVmcUY9mZUa8H-@mail.gmail.com>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/11, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-03-07 12:14, Sedat Dilek wrote:
>> On 3/7/11, Tejun Heo <tj@kernel.org> wrote:
>>> On Mon, Mar 07, 2011 at 11:41:23AM +0100, Sedat Dilek wrote:
>>>> $ git log -1 | cat
>>>> commit c45165cd2c77843f24ca18af54044303dc2a81ab
>>>> Author: Stephen Rothwell <sfr@canb.auug.org.au>
>>>> Date:   Mon Mar 7 17:38:41 2011 +1100
>>>>
>>>>     Add linux-next specific files for 20110307
>>>>
>>>>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>>>
>>>> $ git pull
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
>>>> for-next
>>>> remote: Counting objects: 158, done.
>>>> remote: Compressing objects: 100% (89/89), done.
>>>> remote: Total 106 (delta 87), reused 21 (delta 17)
>>>> Receiving objects: 100% (106/106), 23.33 KiB, done.
>>>> Resolving deltas: 100% (87/87), completed with 34 local objects.
>>>> From git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block
>>>>  * branch            for-next   -> FETCH_HEAD
>>>> warning: too many files (created: 1120 deleted: 637), skipping inexact
>>>> rename detection
>>>> warning: too many files (created: 974 deleted: 462), skipping inexact
>>>> rename detection
>>>> Auto-merging block/blk-core.c
>>>> Auto-merging block/blk-flush.c
>>>> CONFLICT (content): Merge conflict in block/blk-flush.c
>>>> Auto-merging block/cfq-iosched.c
>>>> CONFLICT (content): Merge conflict in block/cfq-iosched.c
>>>> Automatic merge failed; fix conflicts and then commit the result.
>>>
>>> Ummm... don't those conflicts come from Stephen's commits?  You would
>>> need to revert the merge and fixup commits and then pull in the block
>>> branch.
>>>
>>> Thanks.
>>>
>>> --
>>> tejun
>>>
>>
>> I have reverted the merge-fix from Stephen "[PATCH] block: update for
>> __blk_run_queue() API update" which changed block/blk-flush.c, this
>> remains:
>> ...
>> CONFLICT (content): Merge conflict in block/cfq-iosched.c
>>
>> As it is 12p.m. and sun shining, my decision and direction is clear:
>> Lunch + City.
>
> Just checked here, I can pull my for-next cleanly into Linus' master.
> What is the block tree for-next branch sha?
>
> --
> Jens Axboe
>
>

No, I tried to merge your for-next into linux-next (which will happen
with tomorrows linux-next).

[ linux-2.6-block.git#for-next ]
commit b873c5d692d4d5453cceed18bb06c62bb1a73ac0
"Merge branch 'block-for-2.6.39-core' of
ssh:///linux/kernel/git/tj/misc into for-2.6.39/core"

- Sedat -
