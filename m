Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1CGKrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 05:47:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61351 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1CGKrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 05:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Apyz+8r6EspAY6FdGIN2T8kJRYa4kQ5TRtOAZVZBg9bXPEZ01EgT+yz3qMEmCrC2jB
         QNj9ttTtm0UIbw0a3ZlPKrlVe/YE5H90uOoG7FFmRtwxJKKr8BpVFxeJdSVx85eyD2Bt
         jFlR1K/yxLunXnuYNinNQFIMRIHcBeOhx3+k8=
Date: Mon, 7 Mar 2011 11:47:47 +0100
From: Tejun Heo <tj@kernel.org>
To: sedat.dilek@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20110307104747.GH20499@htj.dyndns.org>
References: <20110307131958.84a5d818.sfr@canb.auug.org.au>
 <20110307063618.GA10365@mtj.dyndns.org>
 <4D749A81.50809@kernel.dk>
 <AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim0qwr-L9RLRDtoZBrFBWGJ1ze9LMxr9dTmdrr9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:41:23AM +0100, Sedat Dilek wrote:
> $ git log -1 | cat
> commit c45165cd2c77843f24ca18af54044303dc2a81ab
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Mar 7 17:38:41 2011 +1100
> 
>     Add linux-next specific files for 20110307
> 
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git
> for-next
> remote: Counting objects: 158, done.
> remote: Compressing objects: 100% (89/89), done.
> remote: Total 106 (delta 87), reused 21 (delta 17)
> Receiving objects: 100% (106/106), 23.33 KiB, done.
> Resolving deltas: 100% (87/87), completed with 34 local objects.
> From git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block
>  * branch            for-next   -> FETCH_HEAD
> warning: too many files (created: 1120 deleted: 637), skipping inexact
> rename detection
> warning: too many files (created: 974 deleted: 462), skipping inexact
> rename detection
> Auto-merging block/blk-core.c
> Auto-merging block/blk-flush.c
> CONFLICT (content): Merge conflict in block/blk-flush.c
> Auto-merging block/cfq-iosched.c
> CONFLICT (content): Merge conflict in block/cfq-iosched.c
> Automatic merge failed; fix conflicts and then commit the result.

Ummm... don't those conflicts come from Stephen's commits?  You would
need to revert the merge and fixup commits and then pull in the block
branch.

Thanks.

-- 
tejun
