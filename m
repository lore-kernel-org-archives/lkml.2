Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1CJL0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:26:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52095 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807Ab1CJL0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:26:05 -0500
Message-ID: <4D78B54B.2060803@kernel.dk>
Date: Thu, 10 Mar 2011 12:26:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD bits for 2.6.39
References: <201103091523.51815.philipp.reisner@linbit.com> <4D789ED1.6060905@kernel.dk> <201103101200.24005.philipp.reisner@linbit.com>
In-Reply-To: <201103101200.24005.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 12:00, Philipp Reisner wrote:
> [...]
>> Philip, sorry for the extra work, but can I please ask you to rebase
>> this on the new for-2.6.39/core? Two things happened:
>>
>> - I pulled in the stack-plug changes, it's causing a few conflicts. All
>>   of them are trivial, so that's not a real worry.
>>
>> - I had to rebase for-2.6.39/core to get rid of an OOPS in the
>>   ->check_events() changes from Tejun.
> 
> Hi Jens,
> 
> Done, it is rebased:
> 
> The following changes since commit 4c63f5646e405b5010cc9499419060bf2e838f5b:
> 
>   Merge branch 'for-2.6.39/stack-plug' into for-2.6.39/core (2011-03-10 
> 08:58:35 +0100)
> 
> are available in the git repository at:
> 
>   git://git.drbd.org/linux-2.6-drbd.git for-jens

Awesome, thanks!

Now that I have your attention... Did you look at the plugging changes?
As Christoph mentioned, you seem to be passing plugging information on
the wire. What is the reason for that? With the on-stack plugging, these
events are not seen by the block device anymore.

> BTW, since we got a request for a "summary change-log":

Yes, please do that in the future, it's good to have a verbalized
summary outside of the shortlog.

-- 
Jens Axboe

