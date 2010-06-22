Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab0FVG0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:26:05 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0FVG0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:26:04 -0400
Message-ID: <4C205779.20704@kernel.dk>
Date: Tue, 22 Jun 2010 08:26:01 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the tip tree with the block tree
References: <20100621161623.3dfedc32.sfr@canb.auug.org.au> <20100621171300.GF2354@linux.vnet.ibm.com> <20100622094033.3becf09f.sfr@canb.auug.org.au> <20100622100423.205ae0a4.sfr@canb.auug.org.au> <20100622004030.GN2354@linux.vnet.ibm.com>
In-Reply-To: <20100622004030.GN2354@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-22 02:40, Paul E. McKenney wrote:
> On Tue, Jun 22, 2010 at 10:04:23AM +1000, Stephen Rothwell wrote:
>> Hi Paul,
>>
>> On Tue, 22 Jun 2010 09:40:33 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> On Mon, 21 Jun 2010 10:13:00 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
>>>>
>>>> I took a look, and all of the changes from "fs: remove all rcu head
>>>> initializations, except on_stack initializations" are reflected in -next.
>>>
>>> Thanks for checking.
>>
>> Is there some way that this commit can be merged via the block tree?  Or
>> does later work in your tree depend on it?  There is considerable and
>> ongoing work in the block tree on the same areas as your commit changes.
>> Even today, this conflict is going to be much worse.
> 
> I have no problem with this patch being applied via the block tree, as
> long as it doesn't take too many minor releases for it to hit mainline.  ;-)
> 
> How would everyone like to proceed?

The stuff in the block tree is either destined for the current release
or the next one, the patches going into for-next are a merge of those
two parts.

Is this rcu patch for .35 or .36?

-- 
Jens Axboe

