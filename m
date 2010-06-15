Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0FOSpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:45:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:57572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758526Ab0FOSpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:45:44 -0400
Message-ID: <4C17CA0C.80301@kernel.org>
Date: Tue, 15 Jun 2010 20:44:28 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <4C17C598.7070303@kernel.org> <alpine.DEB.2.00.1006151339510.9635@router.home>
In-Reply-To: <alpine.DEB.2.00.1006151339510.9635@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 18:44:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/15/2010 08:40 PM, Christoph Lameter wrote:
> On Tue, 15 Jun 2010, Tejun Heo wrote:
> 
>> == Benefits
>>
>> * Less to worry about causing deadlocks around execution resources.
>>
>> * Far fewer number of kthreads.
>>
>> * More flexibility without runtime overhead.
>>
>> * As concurrency is no longer a problem, workloads which needed
>>   separate mechanisms can now use generic workqueue instead.  This
>>   easy access to concurrency also allows stuff which wasn't worth
>>   implementing a dedicated mechanism for but still needed flexible
>>   concurrency.
> 
> Start the whole with the above? Otherwise people get tired of reading
> before finding out what the point of the exercise is?

Yeah, maybe that would have been better.  I was going for a nice
closing but who cares about closing if the opening is boring.  I'll
reorder on the next round.

Thanks.

-- 
tejun
