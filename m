Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab0JEGxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:53:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:59549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab0JEGxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:53:42 -0400
Message-ID: <4CAACBDA.6090308@kernel.org>
Date: Tue, 05 Oct 2010 08:55:22 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the lost-spurious-irq tree with the
 tip tree
References: <20101005141334.6a0f15fd.sfr@canb.auug.org.au> <4CAABC0E.3030700@kernel.org> <20101005063227.GB12267@elte.hu>
In-Reply-To: <20101005063227.GB12267@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Oct 2010 06:53:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 10/05/2010 08:32 AM, Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
>>> I think I fixed it all up (see below).  I can carry this fix (or a 
>>> better one) as necessary.
>>
>> Can you please drop lost-spurious-irq for now?  It needs to be 
>> reimplemented.  I'll send a merge request again when it's ready.
> 
> Please send irq merge requests to Thomas instead and wait for those 
> genirq bits to show up upstream. (You did so in the past and the review 
> process was ongoing AFAICS)
> 
> Otherwise we would be dilluting linux-next testing with random side 
> effects from a tree that wasnt yet (in that form) scheduled to go 
> upstream by its respective maintainer at that time.
> 
> We were lucky that this showed up as merge complications - what if 
> instead it merged 'fine' on the textual and build/boot level but 
> mis-merged on the functional level in subtle ways? Thomas would be 
> sending something to Linus that was never really tested in linux-next in 
> that form, caused problems upstream, and Linus would be rightfully upset 
> about the situation.
> 
> Stephen, you need to enforce such things ...

I think Stephen had done enough.  At the time, I wasn't sure which
tree it was going to go through and it took some time before Thomas
responded, so I was intending to push it through separately.  I should
have retracted the tree right after it was determined to be
reimplemented but forgot.  That's my mistake not Stephen's.  Sorry
about that.

Thanks.

-- 
tejun
