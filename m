Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab1CGKl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:41:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49402 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1CGKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:41:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=dD+Kxi+/bHpO4cLuFqPYcHtdpzU4pKKl5yNtiwGNdACAippG4avomk/0Kmbj303yeD
         sKyyqkqeq7VqgfCtt+7Ik0+YGGvjkApIDCmURkEAR8l4y4u1YjKNCMkNF2KPi7MO4SgY
         62eZPxl6JjzVs4S36jBxTcFlBRi0qZiVbERHI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D749A81.50809@kernel.dk>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
	<20110307063618.GA10365@mtj.dyndns.org>
	<4D749A81.50809@kernel.dk>
Date: Mon, 7 Mar 2011 11:41:23 +0100
Message-ID: <AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still merge conflicts with last commit [1].

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=commit;h=b873c5d692d4d5453cceed18bb06c62bb1a73ac0

$ git log -1 | cat
commit c45165cd2c77843f24ca18af54044303dc2a81ab
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Mon Mar 7 17:38:41 2011 +1100

    Add linux-next specific files for 20110307

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

$ git pull git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
for-next
remote: Counting objects: 158, done.
remote: Compressing objects: 100% (89/89), done.
remote: Total 106 (delta 87), reused 21 (delta 17)
Receiving objects: 100% (106/106), 23.33 KiB, done.
Resolving deltas: 100% (87/87), completed with 34 local objects.
>From git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block
 * branch            for-next   -> FETCH_HEAD
warning: too many files (created: 1120 deleted: 637), skipping inexact
rename detection
warning: too many files (created: 974 deleted: 462), skipping inexact
rename detection
Auto-merging block/blk-core.c
Auto-merging block/blk-flush.c
CONFLICT (content): Merge conflict in block/blk-flush.c
Auto-merging block/cfq-iosched.c
CONFLICT (content): Merge conflict in block/cfq-iosched.c
Automatic merge failed; fix conflicts and then commit the result.



On 3/7/11, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-03-07 07:36, Tejun Heo wrote:
>> Hello, Stephen, Jens.
>>
>> On Mon, Mar 07, 2011 at 01:19:58PM +1100, Stephen Rothwell wrote:
>>> Today's linux-next merge of the block tree got a conflict in
>>> block/blk-flush.c between commit 255bb490c8c27eed484d538efe6ef6a7473bd3f6
>>> ("block: blk-flush shouldn't call directly into q->request_fn()
>>> __blk_run_queue()") from the  tree and commit
>>> ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae ("block: reimplement FLUSH/FUA
>>> to support merge") from the block tree.
>>>
>>> The latter rewrote a large part of the file, so I just used that.  If
>>> this is not correct, please fix it up in the block tree.
>>
>> I sent Jens a merge commit which should fix this yesterday.
>>
>>  http://thread.gmane.org/gmane.linux.kernel/1101766/focus=1108915
>>
>> So, the merge problem should go away soonish.
>
> Merged now, so this conflict should be gone from linux-next as of now.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
