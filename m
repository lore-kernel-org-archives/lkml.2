Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab1CGImo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:42:44 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40361 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1CGImm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:42:42 -0500
Message-ID: <4D749A81.50809@kernel.dk>
Date: Mon, 07 Mar 2011 09:42:41 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
References: <20110307131958.84a5d818.sfr@canb.auug.org.au> <20110307063618.GA10365@mtj.dyndns.org>
In-Reply-To: <20110307063618.GA10365@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 07:36, Tejun Heo wrote:
> Hello, Stephen, Jens.
> 
> On Mon, Mar 07, 2011 at 01:19:58PM +1100, Stephen Rothwell wrote:
>> Today's linux-next merge of the block tree got a conflict in
>> block/blk-flush.c between commit 255bb490c8c27eed484d538efe6ef6a7473bd3f6
>> ("block: blk-flush shouldn't call directly into q->request_fn()
>> __blk_run_queue()") from the  tree and commit
>> ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae ("block: reimplement FLUSH/FUA
>> to support merge") from the block tree.
>>
>> The latter rewrote a large part of the file, so I just used that.  If
>> this is not correct, please fix it up in the block tree.
> 
> I sent Jens a merge commit which should fix this yesterday.
> 
>  http://thread.gmane.org/gmane.linux.kernel/1101766/focus=1108915
> 
> So, the merge problem should go away soonish.

Merged now, so this conflict should be gone from linux-next as of now.

-- 
Jens Axboe

